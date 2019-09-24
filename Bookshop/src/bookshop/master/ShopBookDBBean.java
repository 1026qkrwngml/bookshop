package bookshop.master;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

//-----------------------------------------------------------
// class ShopBookDBBean 
//-----------------------------------------------------------
public class ShopBookDBBean 
{
	private static ShopBookDBBean instance = new ShopBookDBBean();
	
	public static ShopBookDBBean getInstance() {
		return instance;
	}
	
	private ShopBookDBBean() {}
	
	//-----------------------------------------------------------
	//커넥션 풀로부터 커넥션 개체를 얻어내는 메서드
	//-----------------------------------------------------------
	private Connection getConnection() throws Exception {
		Context	initCtx = new InitialContext();
		Context envCtx	= (Context)  initCtx.lookup("java:comp/env");
		DataSource ds	= (DataSource)envCtx.lookup("jdbc/bookshopdb");
		return ds.getConnection();
		
	} // End - private Connection getConnection()
	
	//-----------------------------------------------------------
	//관리자 인증 메서드
	//-----------------------------------------------------------
	public int managerCheck(String id, String passwd) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		String		dbpasswd = "";
		int			rtnVal 	 = -1;
		
		try {
			conn = getConnection();
			
			pstmt = conn.prepareStatement(
					"SELECT managerPasswd FROM manager WHERE managerId=?");
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) { // 해당 아이디 정보가 있으면
				dbpasswd = rs.getString("managerPasswd");
				if(dbpasswd.equals(passwd)) {
					rtnVal = 1; //인증 성공
				} else {
					rtnVal = 0; //비밀번호 틀림
				}
			} else {
				rtnVal = -1; //해당 아이디 없음.
			}
			
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnVal;
	} // End - public int managerCheck(String id, String passwd)

	//-----------------------------------------------------------
	//책 등록 메서드
	//-----------------------------------------------------------
	public void insertBook(ShopBookDataBean book) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		String				sql		= "";
		try {
			conn = getConnection();
			sql = "INSERT INTO book VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt		( 1, book.getBook_id());
			pstmt.setString		( 2, book.getBook_kind());
			pstmt.setString		( 3, book.getBook_title());
			pstmt.setInt		( 4, book.getBook_price());
			pstmt.setShort		( 5, book.getBook_count());
			pstmt.setString		( 6, book.getAuthor());
			pstmt.setString		( 7, book.getPublishing_com());
			pstmt.setString		( 8, book.getPublishing_date());
			pstmt.setString		( 9, book.getBook_image());
			pstmt.setString		(10, book.getBook_content());
			pstmt.setByte		(11, book.getDiscount_rate());
			pstmt.setTimestamp	(12, book.getReg_date());
			
			pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void insertBook(ShopBookDataBean book)
	
	//-----------------------------------------------------------
	//등록된 책의 전체 권수를 구하는 메서드
	//-----------------------------------------------------------
	public int getBookCount() throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		int					rtnCnt	= 0;
		
		try {
			conn 	= getConnection();
			pstmt 	= conn.prepareStatement("SELECT COUNT(*) FROM book");
			rs		= pstmt.executeQuery();
			if(rs.next())
				rtnCnt = rs.getInt(1);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnCnt;
	} // End - public int getBookCount()
	
	//-----------------------------------------------------------
	//책의 종류에 따른 전체 권수를 구하는 메서드
	//-----------------------------------------------------------
	public int getBookCount(String book_kind) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		String				sql		= null;
		int					rtnCnt	= 0;
		
		try {
			conn 	= getConnection();
			sql = "SELECT COUNT(*) FROM book WHERE book_kind = ?";
			pstmt 	= conn.prepareStatement(sql);
			pstmt.setString(1, book_kind);
			rs		= pstmt.executeQuery();
			
			if(rs.next())
				rtnCnt = rs.getInt(1);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnCnt;
	} // End - public int getBookCount()
	
	//-----------------------------------------------------------
	//분류별 또는 전체 등록된 책의 정보를 구하는 메서드
	//-----------------------------------------------------------
	public List<ShopBookDataBean> getBooks(String book_kind) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		List<ShopBookDataBean>	bookList = null;
		
		try {
			conn	= getConnection();
			String	sql1 = "SELECT * FROM book ";
			String	sql2 = " WHERE book_kind=? ORDER BY reg_date DESC";
			
			if(book_kind.equals("all")) {
				pstmt = conn.prepareStatement(sql1);
			} else {
				pstmt = conn.prepareStatement(sql1+sql2);
				pstmt.setString(1, book_kind);
			}
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				bookList = new ArrayList<ShopBookDataBean>();
				do {
					ShopBookDataBean book = new ShopBookDataBean();
					
					book.setBook_id			(rs.getInt("book_id"));
					book.setBook_kind		(rs.getString("book_kind"));
					book.setBook_title		(rs.getString("book_title"));
					book.setBook_price		(rs.getInt("book_price"));
					book.setBook_count		(rs.getShort("book_count"));
					book.setAuthor			(rs.getString("author"));
					book.setPublishing_com	(rs.getString("publishing_com"));
					book.setPublishing_date	(rs.getString("publishing_date"));
					book.setBook_image		(rs.getString("book_image"));
					book.setDiscount_rate	(rs.getByte("discount_rate"));
					book.setReg_date		(rs.getTimestamp("reg_date"));
							
					bookList.add(book);
				} while(rs.next());
			}
			
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return bookList;
	} // End - public List<ShopBookDataBean> getBooks(String book_kind)

	//-----------------------------------------------------------------
	//책종류별 신간서적 3권을 가져오는 메서드
	//쇼핑몰 메인에서 사용하기 위해서
	//-----------------------------------------------------------------
	public ShopBookDataBean[] getBooks(String book_kind, int count)
		throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		ShopBookDataBean	bookList[]	= null;
		int i = 0;
		int rtnCount = 0;
		String sql = "";
		
		try {
			conn = getConnection();
			
			//limit의 조회건수보다 실제데이터가 적으면 NULL문제가 발생하므로
			//먼저 해당자료의 건수를 구한다.
			//조회할 건수보다 실제데이터가 적으면 적은만큼만 limit로 검색한다.
			sql = "SELECT COUNT(*) FROM book WHERE book_kind=?"; 
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, book_kind);
			rs = pstmt.executeQuery();
			if(rs.next())
				rtnCount = rs.getInt(1);
			
			//검색하려는 데이터 건수가 실제데이터의 건수보다 많으면 
			//실제데이터의 건수만큼만 검색한다.
			if(rtnCount > count)	rtnCount = count;
			pstmt.close();
			rs.close();
			
			//데이터가 없으면 검색할 필요가 없다.
			if(rtnCount > 0) {
				sql  = "";
				sql += "SELECT * FROM book WHERE book_kind=? ";
				sql += "ORDER BY reg_date DESC limit ?, ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, book_kind);
				pstmt.setInt(2, 0);
				pstmt.setInt(3, rtnCount);
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					bookList = new ShopBookDataBean[count];
					do {
						ShopBookDataBean book = new ShopBookDataBean();

						book.setBook_id			(rs.getInt	 ("book_id"));
						book.setBook_kind		(rs.getString("book_kind"));
						book.setBook_title		(rs.getString("book_title"));
						book.setBook_price		(rs.getInt	 ("book_price"));
						book.setBook_count		(rs.getShort ("book_count"));
						book.setAuthor			(rs.getString("author"));
						book.setPublishing_com	(rs.getString("publishing_com"));
						book.setPublishing_date	(rs.getString("publishing_date"));
						book.setBook_image		(rs.getString("book_image"));
						book.setDiscount_rate	(rs.getByte	 ("discount_rate"));
						book.setReg_date		(rs.getTimestamp("reg_date"));

						bookList[i] = book;
						i++;
					} while(rs.next());
				}
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
		return bookList;
	} // End - public ShopBookDataBean[] getBooks(String book_kind, int count)

	//-----------------------------------------------------------------
	//bookId에 해당하는 책의 정보를 구하는 메서드
	//등록된 책의 정보를 수정하기 위해 수정화면에서 사용.
	//-----------------------------------------------------------------
	public ShopBookDataBean getBook(int bookId) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		ShopBookDataBean	book	= null;

		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("SELECT * FROM book WHERE book_id=?");
			pstmt.setInt(1, bookId);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				book = new ShopBookDataBean();
				
				book.setBook_kind		(rs.getString("book_kind"));
				book.setBook_title		(rs.getString("book_title"));
				book.setBook_price		(rs.getInt   ("book_price"));
				book.setBook_count		(rs.getShort ("book_count"));
				book.setAuthor			(rs.getString("author"));
				book.setPublishing_com	(rs.getString("publishing_com"));
				book.setPublishing_date	(rs.getString("publishing_date"));
				book.setBook_image		(rs.getString("book_image"));
				book.setBook_content	(rs.getString("book_content"));
				book.setDiscount_rate	(rs.getByte  ("discount_rate"));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return book;
	} // End - public ShopBookDataBean getBook(int bookId)
	
	//-----------------------------------------------------------
	//등록된 책의 정보를 수정하는 메서드
	//-----------------------------------------------------------
	public void updateBook(ShopBookDataBean book, int bookId) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		String				sql		= "";
		
		try {
			conn = getConnection();
			sql  = "UPDATE book SET ";
			sql += "book_kind=?, book_title=?, book_price=?, book_count=?, ";
			sql += "author=?, publishing_com=?, publishing_date=?, ";
			sql += "book_image=?, book_content=?, discount_rate=? ";
			sql += "WHERE book_id=?";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString		( 1, book.getBook_kind());
			pstmt.setString		( 2, book.getBook_title());
			pstmt.setInt		( 3, book.getBook_price());
			pstmt.setShort		( 4, book.getBook_count());
			pstmt.setString		( 5, book.getAuthor());
			pstmt.setString		( 6, book.getPublishing_com());
			pstmt.setString		( 7, book.getPublishing_date());
			pstmt.setString		( 8, book.getBook_image());
			pstmt.setString		( 9, book.getBook_content());
			pstmt.setByte		(10, book.getDiscount_rate());
			pstmt.setInt		(11, bookId);
			
			pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		
	} // End - public void updateBook(ShopBookDataBean book, int bookId)
	
	//-----------------------------------------------------------
	//bookId에 해당하는 책의 정보를 삭제하는 메서드
	//-----------------------------------------------------------
	public void deleteBook(int bookId) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("DELETE FROM book WHERE book_id=?");
			pstmt.setInt(1, bookId);
			pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void deleteBook(int bookId)
	
	//-----------------------------------------------------------
	// book_id에 해당하는 재고 수량을 구하는 메서드 
	//-----------------------------------------------------------
	public int getBookIdCount(int bookId) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		int rtnCount = 0;
		String sql = "";
		
		try {
			conn  = getConnection();
			sql   = "SELECT book_count FROM book WHERE book_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, bookId);
			rs    = pstmt.executeQuery();
			
			if(rs.next()) {
				//rtnCount = rs.getByte(1);
				rtnCount = rs.getInt(1);
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
	} // End - public byte getBookIdCount(int bookId)
	
	
} // End - class ShopBookDBBean




























