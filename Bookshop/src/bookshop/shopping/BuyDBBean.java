package bookshop.shopping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

//-----------------------------------------------------------------
//public class BuyDBBean
//-----------------------------------------------------------------
public class BuyDBBean {
	private static BuyDBBean instance = new BuyDBBean();
	
	//-----------------------------------------------------------------
	// getInstance()
	//-----------------------------------------------------------------
	public static BuyDBBean getInstance() {
		return instance;
	} // End - public static BuyDBBean getInstance()
	
	//-----------------------------------------------------------------
	// 기본 생성자
	//-----------------------------------------------------------------
	private BuyDBBean() {}
	
	//-----------------------------------------------------------------
	// getConnection()
	//-----------------------------------------------------------------
	private Connection getConnection() throws Exception {
		Context initCtx = new InitialContext();
		Context envCtx  = (Context)initCtx.lookup("java:comp/env");
		DataSource ds = (DataSource)envCtx.lookup("jdbc/bookshopdb");
		return ds.getConnection();
	}
	
	//-----------------------------------------------------------------
	// bank테이블에 있는 전체 계좌 정보를 구하는 메서드
	//-----------------------------------------------------------------
	public List<String> getAccount() {
		Connection			conn			= null;
		PreparedStatement	pstmt			= null;
		ResultSet			rs				= null;
		String				sql				= "";
		List<String>		accountLists	= null;
		
		try {
			conn  = getConnection();
			
			sql   = "SELECT * FROM bank";
			pstmt = conn.prepareStatement(sql);
			rs    = pstmt.executeQuery();
			
			accountLists = new ArrayList<String>();
			
			while(rs.next()) {
				String account = "";
				account  = new String(rs.getString("account") + " " 
									+ rs.getString("bank") + " " 
									+ rs.getString("name"));
				accountLists.add(account);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return accountLists;
	} // End - public List<String> getAccount()
	
	//-----------------------------------------------------------------
	// 구매확정을 하면 발생하는 트랜잭션
	//-----------------------------------------------------------------
	public void insertBuy(List<CartDataBean> lists,
			String id, String account, String deliveryName, String deliveryTel,
			String deliveryAddress) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		Timestamp			reg_date= null;
		
		String	sql			= "";
		String	maxDate		= "";
		String	number		= "";
		String	todayDate	= "";
		String	compareDate	= "";
		
		long	buyId		= 0;
		short	nowCount	= 0;
		
		try {
			conn		= getConnection();
			
			reg_date	= new Timestamp(System.currentTimeMillis());
			todayDate	= reg_date.toString();
			compareDate	= todayDate.substring(0,  4) 
						+ todayDate.substring(5,  7)
						+ todayDate.substring(8, 10);
			sql   = "SELECT MAX(buy_id) FROM buy";
			pstmt = conn.prepareStatement(sql);
			rs    = pstmt.executeQuery();
			rs.next();
			
			if(rs.getLong(1) > 0) {
				Long val = new Long(rs.getLong(1));
				maxDate	 = val.toString().substring(0, 8);
				number	 = val.toString().substring(8);
				//오늘날짜와 구매테이블에 있는 제일 큰 날짜와 비교
				if(compareDate.equals(maxDate)) {
					if((Integer.parseInt(number)+1) < 10000) {
						buyId = Long.parseLong(maxDate 
								+ (Integer.parseInt(number)+1+10000));
					} else {
						buyId = Long.parseLong(maxDate 
								+ (Integer.parseInt(number)+1));
					}
				} else { 
					//오늘날짜와 구매테이블에 있는 제일 큰 날짜와 비교해서
					//날짜가 틀리면 오늘날짜뒤에 00001을 붙여서 buyId를 
					//만든다.
					compareDate += "00001";
					buyId = Long.parseLong(compareDate);
				}
			} else {
				//구매테이블에 맨처음으로 데이터가 기록되는 경우
				compareDate += "00001";
				buyId = Long.parseLong(compareDate);
			} // End - buyId 구하기 
			
			//-----------------------------------------------------------------
			// Transaction 시작
			//-----------------------------------------------------------------
			//AutoCommit을 비활성화 시킨다.
			conn.setAutoCommit(false);
			
			for(int i = 0; i < lists.size(); i++)
			{
				CartDataBean cart = lists.get(i);
				
				sql  = "INSERT INTO BUY ";
				sql += "(buy_id, buyer, book_id, book_title, buy_price, buy_count, ";
				sql += "book_image, buy_date, account, deliveryName, deliveryTel, ";
				sql += "deliveryAddress) ";
				sql += "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setLong		( 1, buyId);
				pstmt.setString		( 2, id);
				pstmt.setInt		( 3, cart.getBook_id());
				pstmt.setString		( 4, cart.getBook_title());
				pstmt.setInt		( 5, cart.getBuy_price());
				pstmt.setByte		( 6, cart.getBuy_count());
				pstmt.setString		( 7, cart.getBook_image());
				pstmt.setTimestamp	( 8, reg_date);
				pstmt.setString		( 9, account);
				pstmt.setString		(10, deliveryName);
				pstmt.setString		(11, deliveryTel);
				pstmt.setString		(12, deliveryAddress);
				
				pstmt.executeUpdate();
				pstmt.close();
				
				//카트에 있는 상품이 구매되었으므로 
				//book테이블에 있는 상품의 수량을 재조정해야 한다.
				sql = "";
				sql = "SELECT book_count FROM book WHERE book_id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, cart.getBook_id());
				rs = pstmt.executeQuery();
				rs.next();
				
				//재조정되는 수량 = 찾아온 수량 - 카트에 있는 수량
				nowCount = (short)(rs.getShort(1) - cart.getBuy_count());
				
				sql = "";
				sql = "UPDATE book SET book_count=? WHERE book_id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setShort	(1, nowCount);
				pstmt.setInt	(2, cart.getBook_id());
				pstmt.executeUpdate();
			} // End - for
			//카트에 있는 물품들에 대한 계산이 모두 끝나면 카트를 비운다.
			sql = "";
			sql = "DELETE FROM cart WHERE buyer=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
			
			//-----------------------------------------------------------------
			//모든 테이블에 대한 작업이 끝나면 commit()을 실행한다.
			conn.commit();
			conn.setAutoCommit(true);
			//-----------------------------------------------------------------
			// Transaction 끝
			//-----------------------------------------------------------------
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void insertBuy(....)

	//-----------------------------------------------------------------
	// buyer id에 해당하는 레코드의 건수를 구하는 메서드
	//-----------------------------------------------------------------
	public int getListCount(String id) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		String				sql		= "";
		int rtnCnt = 0;
		
		try {
			conn = getConnection();
			sql = "SELECT COUNT(*) FROM buy WHERE buyer=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				rtnCnt = rs.getInt(1);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnCnt;
	} // End - public int getListCount(String id)
	
	//-----------------------------------------------------------------
	// 구매자 id에 해당하는 구매목록을 구하는 메서드
	//-----------------------------------------------------------------
	public List<BuyDataBean> getBuyList(String id) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		String				sql		= "";
		List<BuyDataBean>	lists	= null;
		BuyDataBean			buy		= null;
		
		try {
			conn = getConnection();
			sql = "SELECT * FROM buy WHERE buyer = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			lists = new ArrayList<BuyDataBean>();
			
			while(rs.next()) {
				buy = new BuyDataBean();
				
				buy.setBuy_id(rs.getLong("buy_id"));
				buy.setBook_id(rs.getInt("book_id"));
				buy.setBook_title(rs.getString("book_title"));
				buy.setBuy_price(rs.getInt("buy_price"));
				buy.setBuy_count(rs.getByte("buy_count"));
				buy.setBook_image(rs.getString("book_image"));
				buy.setSanction(rs.getString("sanction"));
				
				lists.add(buy);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return lists;
	} // End - public List<BuyDataBean> getBuyList(String id)
	
	//-----------------------------------------------------------------
	// buy테이블의 전체 레코드 건수를 구하는 메서드
	//-----------------------------------------------------------------
	public int getListCount() throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		String				sql		= "";
		int					rtnCnt	= 0;

		try {
			conn = getConnection();
			
			sql = "SELECT COUNT(*) FROM buy";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				rtnCnt = rs.getInt(1);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnCnt;
	} // End - public int getListCount()
	
	//-----------------------------------------------------------------
	// 전체 판매 목록을 구하는 메서드
	//-----------------------------------------------------------------
	public List<BuyDataBean> getBuyList() throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		String				sql		= "";
		BuyDataBean			buy		= null;
		List<BuyDataBean>	lists	= null;
		
		try {
			conn = getConnection();
			
			sql = "SELECT * FROM buy";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			lists = new ArrayList<BuyDataBean>();
			
			while(rs.next()) {
				buy = new BuyDataBean();
				
				buy.setBuy_id(rs.getLong("buy_id"));
				buy.setBuyer(rs.getString("buyer"));
				buy.setBook_id(rs.getInt("book_id"));
				buy.setBook_title(rs.getString("book_title"));
				buy.setBuy_price(rs.getInt("buy_price"));
				
				buy.setBuy_count(rs.getByte("buy_count"));
				buy.setBook_image(rs.getString("book_image"));
				buy.setBuy_date(rs.getTimestamp("buy_date"));
				buy.setAccount(rs.getString("account"));
				
				buy.setDeliveryName(rs.getString("deliveryName"));
				buy.setDeliveryTel(rs.getString("deliveryTel"));
				buy.setDeliveryAddress(rs.getString("deliveryAddress"));
				buy.setSanction(rs.getString("sanction"));
				
				lists.add(buy);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return lists;
	} // End - public List<BuyDataBean> getBuyList()
	
	//-----------------------------------------------------------------
	// 구매번호로 배송상태를 구하는 메서드
	//-----------------------------------------------------------------
	public int getDeliveryStatus(String buyId) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		String				sql		= "";
		String				status	= "";
		int					rtnVal	= 0;

		try {
			conn = getConnection();
			
			sql = "SELECT sanction FROM buy WHERE buy_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, Long.parseLong(buyId));
			rs = pstmt.executeQuery();
			
			if(rs.next() ) {
				//배송 상태 : 1(상품준비중) 2(배송중) 3(배송완료)
				status = rs.getString("sanction");
				if(status.equals("상품준비중") ) {
					rtnVal = 1;
				} else if(status.equals("배송중") ) {
					rtnVal = 2;
				} else if(status.equals("배송완료") ) {
					rtnVal = 3;
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnVal;
	} // End - public int getDeliveryStatus(String buyId)
	
	//-----------------------------------------------------------------
	// 구매번호에 해당하는 배송 상태를 수정한다.
	//-----------------------------------------------------------------
	public void updateDelivery(String buyId, String status) throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		String				sql			= "";
		String				sanction	= "";
		
		if(Integer.parseInt(status) == 1) {
			sanction = "상품준비중";
		} else if(Integer.parseInt(status) == 2) {
			sanction = "배송중";
		} else if(Integer.parseInt(status) == 3) {
			sanction = "배송완료";
		}
		
		System.out.println("sanction:"+sanction);
		System.out.println("buyId:"+buyId);
		try {
			conn = getConnection();
			sql = "UPDATE buy SET sanction = ? WHERE buy_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString	(1, sanction);
			pstmt.setLong	(2, Long.parseLong(buyId));
			System.out.println("updateDelivery:"+pstmt);
			pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void updateDelivery(String buyId, String status)
	
	//-----------------------------------------------------------------
	// 월별 판매 자료를 구하는 메서드
	//-----------------------------------------------------------------
	public BuyMonthDataBean buyMonth(String year) throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		BuyMonthDataBean	buyMonth	= null;

		try {
			conn = getConnection();
			
			sql  = "SELECT ";
			sql += "IFNULL(SUM(CASE date_format(buy.buy_date, '%m')  WHEN '01' THEN buy_count END), 0) AS 'm01', ";
			sql += "IFNULL(SUM(CASE date_format(buy.buy_date, '%m')  WHEN '02' THEN buy_count END), 0) AS 'm02', ";
			sql += "IFNULL(SUM(CASE date_format(buy.buy_date, '%m')  WHEN '03' THEN buy_count END), 0) AS 'm03', ";
			sql += "IFNULL(SUM(CASE date_format(buy.buy_date, '%m')  WHEN '04' THEN buy_count END), 0) AS 'm04', ";
			sql += "IFNULL(SUM(CASE date_format(buy.buy_date, '%m')  WHEN '05' THEN buy_count END), 0) AS 'm05', ";
			sql += "IFNULL(SUM(CASE date_format(buy.buy_date, '%m')  WHEN '06' THEN buy_count END), 0) AS 'm06', ";
			sql += "IFNULL(SUM(CASE date_format(buy.buy_date, '%m')  WHEN '07' THEN buy_count END), 0) AS 'm07', ";
			sql += "IFNULL(SUM(CASE date_format(buy.buy_date, '%m')  WHEN '08' THEN buy_count END), 0) AS 'm08', ";
			sql += "IFNULL(SUM(CASE date_format(buy.buy_date, '%m')  WHEN '09' THEN buy_count END), 0) AS 'm09', ";
			sql += "IFNULL(SUM(CASE date_format(buy.buy_date, '%m')  WHEN '10' THEN buy_count END), 0) AS 'm10', ";
			sql += "IFNULL(SUM(CASE date_format(buy.buy_date, '%m')  WHEN '11' THEN buy_count END), 0) AS 'm11', ";
			sql += "IFNULL(SUM(CASE date_format(buy.buy_date, '%m')  WHEN '12' THEN buy_count END), 0) AS 'm12', ";
			sql += "IFNULL(SUM(buy_count), 0) AS 'tot'";
			sql += "FROM buy ";
			sql += "WHERE DATE_FORMAT(buy.buy_date, '%Y') = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, year);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				buyMonth = new BuyMonthDataBean();
				
				buyMonth.setMonth01(rs.getInt("m01"));
				buyMonth.setMonth02(rs.getInt("m02"));
				buyMonth.setMonth03(rs.getInt("m03"));
				buyMonth.setMonth04(rs.getInt("m04"));
				buyMonth.setMonth05(rs.getInt("m05"));
				buyMonth.setMonth06(rs.getInt("m06"));
				buyMonth.setMonth07(rs.getInt("m07"));
				buyMonth.setMonth08(rs.getInt("m08"));
				buyMonth.setMonth09(rs.getInt("m09"));
				buyMonth.setMonth10(rs.getInt("m10"));
				buyMonth.setMonth11(rs.getInt("m11"));
				buyMonth.setMonth12(rs.getInt("m12"));
				buyMonth.setTotal  (rs.getInt("tot"));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return buyMonth;
	} // End - public BuyMonthDataBean buyMonth(String year)
	
	//-----------------------------------------------------------------
	// 도서별 년간 판배 비율을 구하는 메서드
	//-----------------------------------------------------------------
	public BuyBookKindDataBean buyBookKindYear(String year) throws Exception {
		Connection			conn		= null;
		PreparedStatement	pstmt		= null;
		ResultSet			rs			= null;
		String				sql			= "";
		BuyBookKindDataBean	buyKind		= null;

		try {
			conn = getConnection();
			
			sql  = "SELECT ";
			sql += "IFNULL(SUM(CASE bk.book_kind WHEN '100' THEN buy_count END), 0) AS 'qty100', ";
			sql += "IFNULL(SUM(CASE bk.book_kind WHEN '200' THEN buy_count END), 0) AS 'qty200', ";
			sql += "IFNULL(SUM(CASE bk.book_kind WHEN '300' THEN buy_count END), 0) AS 'qty300', ";
			sql += "IFNULL(SUM(buy_count), 0) AS 'tot' ";
			sql += "FROM book bk, buy bu ";
			sql += "WHERE bk.book_id = bu.book_id AND DATE_FORMAT(bu.buy_date, '%Y') = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, year);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				buyKind = new BuyBookKindDataBean();
				
				buyKind.setBookQty100(rs.getInt("qty100"));
				buyKind.setBookQty200(rs.getInt("qty200"));
				buyKind.setBookQty300(rs.getInt("qty300"));
				buyKind.setTotal	 (rs.getInt("tot"));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return buyKind;
	} // End - public BuyBookKindDataBean buyBookKindYear(String year)
	
	
	
	
	
	
	
	

} // End - public class BuyDBBean




























