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

import bookshop.master.ShopBookDBBean;

//----------------------------------------------------------------------
// class CustomerDBBean
//----------------------------------------------------------------------
public class CustomerDBBean {

	private static CustomerDBBean instance = new CustomerDBBean();
	
	public static CustomerDBBean getInstance() {
		return instance;
	}
	
	private CustomerDBBean() {}
	
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
	//사용자 ID 중복검사
	//-----------------------------------------------------------------
	public int confirmId(String id) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		int					rtnVal	= -1;
		String				sql		= "";
		
		try {
			conn = getConnection();
			sql = "SELECT id FROM member WHERE id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				rtnVal  = 1;  //id에 해당하는 회원이 이미 있으면
			} else {
				rtnVal = -1; //id에 해당하는 회원이 없으면
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnVal;
	} // End - public int confirmId(String id)
	
	//-----------------------------------------------------------------
	//회원 가입
	//-----------------------------------------------------------------
	public void insertMember(CustomerDataBean member) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		String 				sql		= "";
		
        conn = getConnection();
		/*
		System.out.println("insert Member.....");
		System.out.println(member.getId());
		System.out.println(member.getPasswd());
		System.out.println(member.getName());
		System.out.println(member.getReg_date());
		System.out.println(member.getTel());
		System.out.println(member.getAddress());
		*/
		
		try {
			conn = getConnection();
			sql = "INSERT INTO member VALUES (?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
            pstmt.setString		(1, member.getId());
            pstmt.setString		(2, member.getPasswd());
            pstmt.setString		(3, member.getName());
            pstmt.setTimestamp	(4, member.getReg_date());
            pstmt.setString		(5, member.getTel());
            pstmt.setString		(6, member.getAddress());

            pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {	
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void insertMember(CustomerDataBean member)
	
	//-----------------------------------------------------------------
	//회원 존재여부 검사
	//-----------------------------------------------------------------
	public int userCheck(String id, String passwd) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		String	dbpasswd	= "";
		String	sql			= "";
		int		rtnVal		= -1;
		
		try {
			conn = getConnection();
			sql = "SELECT passwd FROM member WHERE id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dbpasswd = rs.getString("passwd");
				if(dbpasswd.contentEquals(passwd)) {
					rtnVal = 1; //인증성공. 비밀번호 맞음.
				} else {
					rtnVal = 0; //비밀번호 틀림.
				}
			} else {
				rtnVal = -1; //해당 id가 없음.
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return rtnVal;
	} // End - public int userCheck(String id, String passwd)
	
	//-----------------------------------------------------------------
	// 세션아이디에 해당하는 회원의 정보를 구하는 메서드
	//-----------------------------------------------------------------
	public CustomerDataBean getMember(String id) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		String				sql		= "";
		CustomerDataBean	member	= null;
		
		try {
			conn  = getConnection();
			sql   = "SELECT * FROM member WHERE id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs    = pstmt.executeQuery();
			
			if(rs.next()) {
				member = new CustomerDataBean();
				
				member.setId		(rs.getString("id"));
				member.setPasswd	(rs.getString("passwd"));
				member.setName		(rs.getString("name"));
				member.setReg_date	(rs.getTimestamp("reg_date"));
				member.setTel		(rs.getString("tel"));
				member.setAddress	(rs.getString("address"));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(rs    != null) try {rs.close();    } catch(SQLException ex) {}
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
		return member;
	} // End - public CustomerDataBean getMember(String id)
	
	//-----------------------------------------------------------------
	// 회원 정보 수정
	//-----------------------------------------------------------------
	public void updateMember(CustomerDataBean member) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		String				sql		= "";
		
		try {
			conn = getConnection();
			sql  = "UPDATE member SET ";
			sql += "passwd=?, name=?, tel=?, address=? ";
			sql += "WHERE id=?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, member.getPasswd());
			pstmt.setString(2, member.getName());
			pstmt.setString(3, member.getTel());
			pstmt.setString(4, member.getAddress());
			pstmt.setString(5, member.getId());
			
			pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close(); } catch(SQLException ex) {}
			if(conn  != null) try {conn.close();  } catch(SQLException ex) {}
		}
	} // End - public void updateMember(CustomerDataBean member)
	
	//-----------------------------------------------------------------
	// 회원 탈퇴
	//-----------------------------------------------------------------
	public int deleteMember(String id, String passwd) throws Exception {
		Connection			conn	= null;
		PreparedStatement	pstmt	= null;
		ResultSet			rs		= null;
		String				sql		= "";
		String				dbPasswd="";
		int					rtnVal	= -1;
		
		try {
			conn = getConnection();
			sql = "SELECT passwd FROM member WHERE id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dbPasswd = rs.getString("passwd");
				if(dbPasswd.contentEquals(passwd)) {
					sql   = "DELETE FROM member WHERE id=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, id);
					pstmt.executeUpdate();
					rtnVal = 1;
				} else { //비밀번호가 틀린 경우
					rtnVal = 0;
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
	} // End - public int deleteMember(String id, String passwd)
	
} // End - public class CustomerDBBean

















