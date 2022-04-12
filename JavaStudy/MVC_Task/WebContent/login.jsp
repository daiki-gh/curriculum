<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Objects"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.function.Function"%>
<%@ page import="skillcheck.bean.ResponseBean"%>
<%@ page import="skillcheck.bean.EmployeeBean"%>
<%@ page import="skillcheck.logger.Logger"%>

<%
    //リクエストより社員番号を取得: 関数型インターフェース（ラムダ式）
    Function<HttpServletRequest, Object[]> rmdGetResponseInfo = (rmdRequest) -> {	//インターフェースを実装したインスタンスを生成
        // request: responseBean
        ResponseBean rb = (ResponseBean) request.getAttribute("responseBean");
        int requestStatus = 0;
        String message = "";
        String empId = "";
        if (Objects.nonNull(rb)) {
            requestStatus = rb.getRequestStaus();
            message = rb.getMessage();
            EmployeeBean emp = rb.getEmplyeeBeanList().stream().findFirst().orElse(null);
            if (Objects.nonNull(emp)) empId = emp.getEmpId();
        }
        return new Object[]{requestStatus, message, empId};
    };

    ResponseBean responseBean = null;
    // エラーメッセージ表示用
    String message = "";	//messageを空文字で初期化
    int requestStatus = 0;	//requestStatusを0で初期化
    String empId = "";		//empIdを空文字で初期化

    try {															//例外処理開始
        if (Objects.isNull(session) || session.isNew()) {			//session == null または sessionが新規に生成したセッション(情報のやりとり)か
            Logger.log(new Throwable(), "セッションなし");				//session == null または sessionが新規に生成した場合、セッションなしを表示
            Object[] objects = rmdGetResponseInfo.apply(request);	//HttpServletRequest型のrequestを受け取ってObject[]型の値をobject配列に入れる
            requestStatus = (int) objects[0];						//requestStatusにint型のobjects[0]を入れる
            message = (String) objects[1];							//massageにString型のobjects[1]を入れる
            empId = (String) objects[2];							//empIdにString型のobjects[2]を入れる
        } else {
            Logger.log(new Throwable(), "セッションあり");				//session != null または sessionが新規に生成していない場合、セッションありを表示
            // session: redirect
            final String redirect = (String) session.getAttribute("redirect");	//sessionの中でredirect(引数)を検索して値を呼び出し、redirectに代入
            if (Objects.nonNull(redirect)) {									//redirect != nullか
                Logger.log(new Throwable(), "redirect = " + redirect);			//redirect != nullの場合、redirect=その値を表示
                message = redirect;												//messageにredirectを代入
                session.invalidate();											//再描画
            }

            if (requestStatus < 2 && message.isEmpty()) {											//requestStatus < 2 かつ messageが空か
                // ログインエラー時
                ResponseBean rb = (ResponseBean) session.getAttribute("responseBean");				//requestStatus < 2 かつ messageが空の場合、sessionの中でresponseBeanを検索してrbに代入
                if (Objects.nonNull(rb)) {															//rb != nullか
                    requestStatus = rb.getRequestStaus();											//rb != nullの場合、requestStatusに_requestStatusを代入
                    message = rb.getMessage();														//massageに_massageを代入
                    EmployeeBean emp = rb.getEmplyeeBeanList().stream().findFirst().orElse(null);	//_employeeBeanListの最初の値をempに代入
                    if (Objects.nonNull(emp)) {														//emp != nullか
                        empId = emp.getEmpId();														//emp != nullの場合、empIdに_empIdを代入
                    }
                }
            }
            Logger.log(new Throwable(), "message = " + message);	//messageを表示
        }
    } catch (Exception e) {											//例外発生時
        Logger.log(new Throwable(), e);								//例外を表示
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- FIXME Step-1-1: login.jspに適用するcssファイルのリンクタグを記述しなさい。-->
<!-- Tips1: common.css、login.cssの2つを適用-->
<!-- Tips2: 適用するcssファイルのパスの書き方に注意 -->
<link rel="stylesheet" type="text/css" href="./css/common.css">
<link rel="stylesheet" type="text/css" href="./css/login.css">
<script type="text/javascript" src="js/common.js"/></script>
<title>ログイン</title>
</head>
<body>
    <input id="hiddenDialog" type="hidden" value="<%=requestStatus == 2 ? message : ""%>"></input>	<!-- requestStatuseが2の場合、messageを表示。2ではない場合、空を表示 -->
    <h2>ログイン</h2>
    <div class="div-login-form">
        <% if (requestStatus < 2 && !message.isEmpty()) { %>										<!-- requestStatusが2より小さいかつmessageが空ではないか -->
            <!-- FIXME Step-1-2: 以下の手順に沿って適当な処理を記述しなさい。 -->
            <!-- 1. エラー（message）表示時に使用するlabelタグの準備-->
            <!-- 2. class属性と、適用するスタイルの記述-->
            <!-- Tips: common.cssより赤色の文字色を定義しているスタイルを確認 -->
            <label class="error-label"><%= message %></label>								<!-- requestStatusが2より小さいかつmessageが空ではない場合、messageを表示 -->
            <br>
        <% } %>
        <!-- FIXME Step-1-3: actionに送信先URIを記述しなさい。 -->
        <!-- Tips: 「/このプロジェクト/web.xmlに記述されているservlet-name」 -->
        <form action="/MVC_Task/employee" method="post">
            <div class="div-input-flex-area">
                <div>
                    <label>社員番号　: </label>
                    <input id="empId" type="text" name="empId" maxlength="5" value="<%=empId%>"><br>
                </div>
                <div>
                    <label>パスワード: </label>
                    <input id="password" type="password" name="password"><br>
                </div>
            </div>
            <div class="div-button-area">
                <input type="hidden" name="sender" value="/login.jsp"></input>
                <button id="btn-login" class="btn-login" name="requestType" value="login">ログイン</button>
            </div>
        </form>
    </div>
</body>
</html>