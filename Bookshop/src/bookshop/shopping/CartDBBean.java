package bookshop.shopping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

//----------------------------------------------------------------------
// class CartDBBean
//----------------------------------------------------------------------
public class CartDBBean {

	private	static CartDBBean instance = new CartDBBean();
		
	//----------------------------------------------------------------------
	// getInstance()
	//----------------------------------------------------------------------
	public static CartDBBean getInstance() {
		return instance;
	} // End - public static CartDBBean getInstance()
	
	//----------------------------------------------------------------------
	// 기본 생성자
	//----------------------------------------------------------------------
	private CartDBBean() {}
	
	//-----------------------------------------------------------------
	//커넥션 풀로부터 커넥션 개체를 얻어내는 메서드
	//-----------------------------------------------------------------
	private Connection getConnection() throws Exception {
		Context	initCtx = new InitialContext();
		Context envCtx	= (Context)  initCtx.lookup("java:comp/env");
		DataSource ds	= (DataSource)envCtx.lookup("jdbc/bookshopdb");
		return ds.getConnection();
	} // End - private Connection getConnection()
	
	//-----------------------------------------------------------------
	// 장바구니에서 book_id에 해당하는 책의 수량을 구하는 메서드
	//-----------------------------------------------------------------
	public byte getBookIdCount(String buyer, int bookId) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		byte rtnCount = 0;
		String sql = "";
		
		try {
			conn = getConnection();
			
			sql  = "SELECT SUM(buy_count) FROM cart";
			sql += "WHERE buyer=? AND book_id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, buyer);
			pstmt.setInt   (2, bookId);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				rtnCount = rs.getByte(1);
			}
		} catch (NullPointerException ex) {
			ex.printStackTrace();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnCount;
	} // End - public byte getBookIdCount(String buyer, int bookId)
	
	//-----------------------------------------------------------------
	// [장바구니에 담기] 버튼을 클릭하면 수행된다.
	//-----------------------------------------------------------------
	public void insertCart(CartDataBean cart) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		String sql = "";

		try {
			conn = getConnection();
			
			sql  = "INSERT INTO cart ";
			sql += "(book_id, buyer, book_title, buy_price, buy_count, book_image) ";
			sql += "VALUES (?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt 	(1, cart.getBook_id());
			pstmt.setString (2, cart.getBuyer());
			pstmt.setString (3, cart.getBook_title());
			pstmt.setInt	(4, cart.getBuy_price());
			pstmt.setByte	(5, cart.getBuy_count());
			pstmt.setString	(6, cart.getBook_image());
			
			pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void insertCart(CartDataBean cart)
	
	//-----------------------------------------------------------------
	// id에 해당하는 레코드의 수를 구하는 메서드
	//-----------------------------------------------------------------
	public int getListCount(String id) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		int rtnCount = 0;
		String sql = "";
		
		try {
			conn = getConnection();
			
			sql = "SELECT COUNT(*) FROM cart WHERE buyer=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				rtnCount = rs.getInt(1);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnCount;
	} // End - public int getListCount(String id)

	//-----------------------------------------------------------------
	// id에 해당하는 레코드의 목록을 구하는 메서드
	//-----------------------------------------------------------------
	public List<CartDataBean> getCart(String id) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		String 				sql 	= "";
		CartDataBean		cart	= null;
		List<CartDataBean>	lists	= null;
		
		try {
			conn = getConnection();
			
			sql = "SELECT * FROM cart WHERE buyer = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			lists = new ArrayList<CartDataBean>();
			
			while(rs.next()) {
				cart = new CartDataBean();
				
				cart.setCart_id(rs.getInt("cart_id"));
				cart.setBook_id(rs.getInt("book_id"));
				cart.setBook_title(rs.getString("book_title"));
				cart.setBuy_price(rs.getInt("buy_price"));
				cart.setBuy_count(rs.getByte("buy_count"));
				cart.setBook_image(rs.getString("book_image"));
				
				lists.add(cart);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return lists;
	} // End - public List<CartDataBean> getCart(String id)

	//-----------------------------------------------------------------
	// 장바구니에서 수량을 수정할 때 사용하는 메서드
	//-----------------------------------------------------------------
	public void updateCount(int cart_id, byte count) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		String 				sql 	= "";
		
		try {
			conn = getConnection();
			sql = "UPDATE cart SET buy_count=? WHERE cart_id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setByte(1, count);
			pstmt.setInt (2, cart_id);
			
			pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void updateCount(int cart_id, byte count)

	//-----------------------------------------------------------------
	// 구매자에 해당하는 모든 장바구니 비우기
	//-----------------------------------------------------------------
	public void deleteAll(String id) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		String 				sql 	= "";
		
		try {
			conn = getConnection();
			sql = "DELETE FROM cart WHERE buyer = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			int rtnVal = pstmt.executeUpdate();
			if(rtnVal > 0) {
				System.out.println(rtnVal + "건이 삭제되었습니다.");
			} else {
				System.out.println("삭제하는데 문제가 발생하였습니다.");
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void deleteAll(String id)
	
	//-----------------------------------------------------------------
	// 선택한 하나의 장바구니만 비우기
	//-----------------------------------------------------------------
	public void deleteList(int cart_id) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		String 				sql 	= "";
		
		try {
			conn = getConnection();
			sql = "DELETE FROM cart WHERE cart_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cart_id);
			
			pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void deleteList(int cart_id)
	
} // End - class CartDBBean

















