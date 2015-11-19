<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="com.ai.appframe2.web.BaseServer"%>
<%@ page import="com.ai.common.i18n.CrmLocaleFactory"%>
<%@ page import="com.ai.appframe2.complex.cache.CacheFactory"%>
<%@ page import="com.asiainfo.crm.common.cache.BsParaDetailCacheImpl"%>
<%@ page import="com.asiainfo.crm.common.ivalues.IBOBsParaDetailValue"%>
<%@ page import="com.ai.common.util.StaticDataUtil"%>
<%@ page import="com.ai.common.ivalues.IBOBsStaticDataValue"%>

<script src="<%=request.getContextPath()%>/crm/common/CrmJsResource.jsp?v=<%=com.ai.common.util.WebUtil.getJsVersion()%>"></script>
<%@ include file="/webframe/common/commonhead.jsp"%>

<%
 /**
 Avoid Repeat Visit
 */
String serialID = null;
if (session != null){
	serialID = (String) request.getSession().getAttribute(BaseServer.WBS_USER_ATTR);
} 
if(!org.apache.commons.lang.StringUtils.isBlank(serialID)){
    String mainHtml = BaseServer.getMainHTML().substring(BaseServer.getMainHTML().
    indexOf(SessionManager.getContextName())+SessionManager.getContextName().length()); 
    request.getRequestDispatcher(mainHtml).forward(request, response);
}
 %>

<html>
<head>
<title><%=CrmLocaleFactory.getResource("BAS1000001")%></title>
<style type="text/css">
BODY {font-family:Arial,"宋体"; background:#f1f6fe url(images/bg.jpg) repeat-x top middle;font-size:12px; margin: 0;overflow:hidden;}
input { background:#ffffff;border-top:1px solid #999999; border-left:1px solid #999999; border-right:1px solid #dedede; border-bottom:1px solid #dedede; height:20px;font-size:12px;;padding:2px;}

A:link {color: #666666; text-decoration: none;}
a:active {color: #666666; text-decoration: none}
A:visited {color: #666666; text-decoration: none}
A:hover {color: #999999; text-decoration: none}

#center{text-align:center; width:100%}
.main{ position:relative;top:120px; height:400px; width:700px; background:url(images/crm_<%=CrmLocaleFactory.getCurrentLocale().toString()%>.jpg) no-repeat;}
.word{position:absolute;left:420px;top:144px;line-height:32px;text-align:right;color:#333333;white-space: nowrap; word-break: keep-all;}
#UserAccount{ position:absolute;left:470px;top:150px;width:168px;background:#F5F5F5 url(images/username.gif);background-position: 1px 1px;background-repeat:no-repeat;padding-left:20px;height:20px;}
#UserPwd{ position:absolute;left:470px;top:182px;width:100px;background:#F5F5F5 url(images/password.gif);background-position: 1px 1px;background-repeat:no-repeat;padding-left:20px;height:20px;}
#UserPwdGet{position:absolute;left:570px;top:181px;}
#UserVertifyCode{ position:absolute;left:470px;top:214px;width:100px;background:#F5F5F5 url(images/code.gif);background-position: 1px 1px;background-repeat:no-repeat;padding-left:20px;height:20px;}
#vertifyCodeImg{position:absolute;top:214px;left:570px;}
a.button{position:absolute;background:url(images/button.gif) left top;display:block;width:67px;height:26px;text-align:center;padding:8px 0 0 0;color:#666666;}
a#Login{left:440px;top:250px;}
a#Reset{left:520px;top:250px;}
a.button:visited{background-position:left top;color:#666666;}
a.button:hover{background-position:right top;color:#FFFFFF;}

#chpsw{left:430px;top:300px; position:absolute;}
#favorite{left:550px;top:300px; position:absolute;}
.copyright{left:220px; bottom:31px; position:absolute;white-space: nowrap; word-break: keep-all;}
</style>
<script language="JavaScript" src="<%=request.getContextPath()%>/jsv2/UserData_v2.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/jsv2/Globe_v2.jsp"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/jsv2/CommUtil.js"></script>

<script language="JavaScript" type="text/JavaScript">
  //验证登陆是否正确
  //界面是否有验证码校验输入框 
  var isVertifyCode = true;

  //BBOSS的编码是11
  var channel_id = "1";

  function UserVerify(account,psw,vertifycode){
    var xml = null;
    var XMLSender = new ActiveXObject("Microsoft.XMLHTTP");
    IPAddr = '';
    var url = "<%=request.getContextPath()%>/baseserver?CHANNEL_ID=" + channel_id + "&EventID=1&LOGIN_USRNAME="+account+"&LOGIN_PSWD="+psw+"&LOGIN_VERFYCODE="+vertifycode
	    +"&IP_ADDR="+IPAddr+"&MAC_ADDR=123456";//hxx add
    XMLSender.Open("POST",url,false);
    XMLSender.setRequestHeader("Content-Type","text/xml; charset=UTF-8");
    XMLSender.send(xml);
    return XMLSender.responseText;
  }
	//增加校验：是否已登录
  function isLogin(account,psw,vertifycode){
		try{
			

		<%
		String isSingle = "";
		IBOBsStaticDataValue[] values = StaticDataUtil.getStaticData("IS_CHANNEL_LOGIN");
		if(values!=null&&values.length>0){
			isSingle = values[0].getCodeValue();
		}
		%>
	var isSingle = "<%=isSingle%>";
	if("Y"==isSingle||"y"==isSingle){
		var xml = null;
	    var XMLSender = new ActiveXObject("Microsoft.XMLHTTP");
	    IPAddr = '';
	    var url = "<%=request.getContextPath()%>/channlLogout?CHANNEL_ID=" + channel_id + "&EventID=100&LOGIN_USRNAME="+account+"&LOGIN_PSWD="+psw+"&LOGIN_VERFYCODE="+vertifycode
		    +"&IP_ADDR="+IPAddr+"&MAC_ADDR=123456";//hxx add
	    XMLSender.Open("POST",url,false);
	    XMLSender.setRequestHeader("Content-Type","text/xml; charset=UTF-8");
	    XMLSender.send(xml);
	    var xml= new ActiveXObject("Msxml.DOMDocument");
	    xml.async = false;
	    var bload = xml.loadXML(XMLSender.responseText);
	    var xmlNode = xml.documentElement;
	    var ud = createUserDataClass(xmlNode);
	    if(null!=ud){
			if("Y"==ud.getValueByName("FLAG")){
			    	var flag =window.confirm("该用户已登录，是否注销上次登录？");
			    	if(!flag){
			    		return false;
			    	}
			}else if("ERROR"==ud.getValueByName("FLAG")){
			    alert(checkLogin.getValueByName("MSG"));
			    if(isVertifyCode && document.all.item("vertifyCodeImg")!=null){
							document.all.item("UserVertifyCode").value="";
							document.all.item("vertifyCodeImg").src="<%=request.getContextPath()%>/vertifycodeservlet";
			    }
				  document.all.item("UserAccount").value="";
				  document.all.item("UserPwd").value="";
				  document.all.item("UserAccount").focus();
				  document.all.item("UserAccount").focus();
			      return false;
			}
	    }
	}
		return true;
	} catch(e) {
		return true;
	}
  }
  
  /**
   * 用户登录
   * @return
   */
  function Login(){
	  var blank = "                                      ";
    var acc = new String(document.all.item("UserAccount").value);
    var psw = new String(document.all.item("UserPwd").value);
    var vertifycode = "";
    if(isVertifyCode){
      vertifycode = new String(document.all.item("UserVertifyCode").value)
    }
    if(blank.indexOf(acc) != -1 || blank.indexOf(psw) != -1){
      alert(crm_i18n_msg("BAC1000001"));
      return;
    }
    if(isVertifyCode && blank.indexOf(vertifycode)!=-1){
      alert(crm_i18n_msg("BAC1000002"));
      return;
    }
    var checkLogin = isLogin(acc,psw,vertifycode);
    if(!checkLogin){
    	return;
    }
    var loginRe = UserVerify(acc,psw,vertifycode);

    //alert("loginRe="+loginRe);
    var xml= new ActiveXObject("Msxml.DOMDocument");
    xml.async = false;
    var bload = xml.loadXML(loginRe);
    //alert(bload);
    var xmlNode = xml.documentElement;
    var ud = createUserDataClass(xmlNode);

    if(ud==null){
      alert(crm_i18n_msg("BAC1000003"));
      return;
    }
    //alert(ud.getValueByName("LOGIN_FLAG"));
    if (ud.getValueByName("LOGIN_FLAG") == "Y"){ //登录成功
       var SUCCESS_MESSAGE = ud.getValueByName("SUCCESS_MESSAGE");
       if(SUCCESS_MESSAGE!=null && SUCCESS_MESSAGE!=''){
				  alert(SUCCESS_MESSAGE);
       }

        var mySrc = ud.getValueByName("MESSAGE");
         var scrWidth=screen.availWidth;
         var scrHeight=screen.availHeight;
         //openWin(mySrc);
         //alert(screen.width+" "+screen.height);
         var self=window.open (ud.getValueByName("MESSAGE"),"","resizable=1");
         self.moveTo(0,0);
         self.resizeTo(scrWidth,scrHeight);
         //window.open (ud.getValueByName("MESSAGE"),"","menubar=no,status=no,resizable=yes,scrollbars=no,toolbar=no,top=0,left=0,width=1024px,height=700px");
	     
	     window.opener = null;
	     window.close();
    }
    else if(ud.getValueByName("MESSAGE")=="CHANGE_PASS") {
	    alert(crm_i18n_msg("BAC1000004"));
	    changePassword();
	    return;
    }
    else {//登录失败
      alert(ud.getValueByName("MESSAGE"));
      if(isVertifyCode && document.all.item("vertifyCodeImg")!=null){
				document.all.item("UserVertifyCode").value="";
				document.all.item("vertifyCodeImg").src="<%=request.getContextPath()%>/vertifycodeservlet";
      }
      var xStr = ud.getValueByName("MESSAGE");
		  //alert(xStr);

		  if(xStr==crm_i18n_msg("BAC1000004")) {
		     document.all.item("UserPwd").value="";
				  document.all.item("UserPwd").focus();
				 document.all.item("UserPwd").focus();
		  }
		  else {
				 document.all.item("UserAccount").value="";
				 document.all.item("UserPwd").value="";
		     document.all.item("UserAccount").focus();
				 document.all.item("UserAccount").focus();
      }
    }
   }

   /**
    * 取消登录
    * @return
    */
   function CancleLogin(){
     top.close();
   }
    /**
    * 输入重置
    * @return
    */
   function Reset(){
      document.all.item("UserAccount").value="";
      document.all.item("UserPwd").value="";
      document.all.item("UserAccount").focus();

   }

   function JumpByEnter(NextElement){
     var lKeyCode = (navigator.appname=="Netscape")?event.which:window.event.keyCode;
     if ( lKeyCode == 13 ){

	   NextElement.focus();
     }
   }

   function IsEnterKeyPress(){
     var lKeyCode = (navigator.appname=="Netscape")?event.which:event.keyCode;
     if ( lKeyCode == 13 ){
       Login();
     }
     else{
       return false;
     }
   } 
   
//获取密码
function PwdGet(){
      window.showModalDialog("<%=request.getContextPath()%>/secframe/common/getPswd.jsp","","scroll:no;resizable:no;status:no;dialogHeight:200px;dialogWidth:400px");
}

//-->
</script>
<SCRIPT LANGUAGE="VBScript">


function openWin(myScr)
  //window.open myScr,vbNull,"menubar=no,resizable=1,status=no,scrollbars=0,top=0,left=0,width=" & screen.Width - 10  & ",height=" & screen.Height - 57打开主界面压缩为1024*768，规范操作界面，上线前请恢复
  window.open myScr,vbNull,"menubar=no,resizable=1,status=no,scrollbars=0,top=0,left=0,width=1024px,height=700px"

  if not (window.opener is null) then
     window.opener = null
     window.close()
  end if

end function

</SCRIPT>
</head>

<body>
<form action="#" target="_self" id="forcsp" name="forcsp" method="post"><input type="hidden" id="user_code" name="user_code"/><input id="user_password" type="hidden" name="user_password"/>
<input type="hidden" id="login_user" name="login_user"/><input id="login_password" type="hidden" name="login_password"/></form>
<div id="center">
<div class="main">
<div class="word">
<%=CrmLocaleFactory.getResource("BAS1000002")%><br>
<%=CrmLocaleFactory.getResource("BAS1000003")%><br>
<%=CrmLocaleFactory.getResource("BAS1000004")%>
</div>
<input type="text" id="UserAccount" onKeyPress="JumpByEnter(UserPwd)" value="" />
<input type="password" id="UserPwd" onKeyPress="IsEnterKeyPress()" value="" />
<ai:button id="UserPwdGet" onclick="PwdGet()" i18nRes="CRM" text="BAS4000040" />
<input type="text" id="UserVertifyCode" onKeyPress="IsEnterKeyPress()" value="1111"><image id="vertifyCodeImg" src="" width="50" height="20" align="absmiddle">
<a href="#" id="Login" name="Submit" onClick="Login()" class="button"><%=CrmLocaleFactory.getResource("BAS1000005")%></a>
<a href="#" id="Reset" name="Submit2" onClick="Reset()" class="button"><%=CrmLocaleFactory.getResource("BAS1000006")%></a>
<div id="chpsw"><img src="images/chpsw.gif" align="absmiddle">&nbsp;<a href="<%=request.getContextPath()%>/webframe/DownLoadCenter.jsp" target="_blank"><%=CrmLocaleFactory.getResource("BAS2000058")%></a></div>
<div id="favorite"><img src="images/favorite.gif" align="absmiddle">&nbsp;<a id="fav" href="javascript:window.external.addFavorite(location.href,'<%=CrmLocaleFactory.getResource("BAS1000001")%>');"  title="<%=CrmLocaleFactory.getResource("BAS1000007")%>"><%=CrmLocaleFactory.getResource("BAS1000008")%></a></div>
<div class="copyright"><%=CrmLocaleFactory.getResource("BAS1000027")%></div>
</div>
</div>

</body>

<script language="JavaScript"> 
 function judgeTime(){
  //对比客户机时间与服务器时间,如相差超过一天,进行提示
	 var curDateObj = new Date();
   var serverDateTime = null;
   try{
	   var serverDateTime = g_GetSysDateTime();
   }catch(e){
    return;
   }
   if(serverDateTime==null)return;

	 var dateTimeArray = serverDateTime.split(" ");
	 var dateArray = dateTimeArray[0].split("-");
	 var timeArray = dateTimeArray[1].split(":");
	 var serverDateObj = null;

	 if(dateArray.length==3 && timeArray.length == 3)
	 {
		   serverDateObj = new Date(dateArray[0],parseInt(dateArray[1],10)-1,parseInt(dateArray[2],10),timeArray[0],timeArray[1],timeArray[2]);
		   var dyMilli = 1000 * 60 * 60 * 24;
		   var minus = Math.floor((curDateObj.getTime()-serverDateObj.getTime())/ dyMilli);

		   if(minus>=1)
		   {
		     alert(crm_i18n_msg("BAC1000005",serverDateTime));
		   }
	 }
 } 
 judgeTime(); 
 document.all.item("UserAccount").focus();
 document.all.item("UserAccount").focus();
 
 //验证码
 <%
 IBOBsParaDetailValue isUseVertifyCode = (IBOBsParaDetailValue)CacheFactory.get(BsParaDetailCacheImpl.class, "X_VERTIFY_CODE_CHANNEL_INDEX");
 if(isUseVertifyCode==null||"0".equals(isUseVertifyCode.getPara1())){
 %>
	 document.all.item("UserVertifyCode").value="";
	 document.all.item("vertifyCodeImg").src="<%=request.getContextPath()%>/vertifycodeservlet";
 <%} else {
 	 session.setAttribute( BaseServer.WBS_VERTIFY_CODE_ATTR, "1234" );
 %>
 document.all.item("UserVertifyCode").value="1234";
 <%
 }
 %>
</script>

</html>
