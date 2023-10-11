// 
var APP_PROP = [];
var APP_COM_PROP = [];
var PHAOP_COM = {
    APP_NAME:"DHCSTOUTPH",
    APP_COM_NAME:"DHCSTCOMMON",
    CAData:"",
    PLUGINS:{
        DATEFMT:"#(DHCPHADATEFMT)#",                    // DHCPHA_CONSTANT.PLUGINS.DATEFMT      系统参数日期格式
        RAFMT:"#(DHCPHARAFMT)#",                        // DHCPHA_CONSTANT.PLUGINS.RAFMT        系统进价金额位数
        SAFMT:"#(DHCPHASAFMT)#"                         // DHCPHA_CONSTANT.PLUGINS.SAFMT        系统售价金额位数
    },
    LogonData:{
        ALL: session['LOGON.GROUPID'] + '^' + session['LOGON.CTLOCID'] + '^' +session['LOGON.USERID'] + '^' +  session['LOGON.HOSPID'],
        ALL2: session['LOGON.GROUPID'] + ',' + session['LOGON.CTLOCID'] + ',' +session['LOGON.USERID'] + ',' +  session['LOGON.HOSPID'],
        GroupId:session['LOGON.GROUPID'],
        LocId:session['LOGON.CTLOCID'],
        LocText:App_LocDesc,
        LocDesc:App_LocDesc,
        UserId:session['LOGON.USERID'],
        UserCode:session['LOGON.USERCODE'],
        UserName:App_UserName,
        HospId:session['LOGON.HOSPID'],
        HospDesc:App_HospDesc
    },
    DEFAULT:{
        localIP:ClientIPAddress,
        phPyPerId:"",       //直接发药的配药人
        phPerId:"",         //登录对应的操作人
        phlId : "",
        winIdStr : "",
        cyFlag : "",        //草药标识
        OweDisp : "",       //欠药发药
        RetNeedReq:"",      //退药需退药申请
        FYCheck:"",             //发药核对
        StDate:"t-3"
    },
    VAR:{
        TIMER:"",
        TIMERSTEP:"",
        WinType:"",
        WayType:"OR",
        WayId:"",  //拒绝代码
        PermissionTpe:"",
        CAModelCode:""
    },
    COOKIE:{
        NAME:session['LOGON.CTLOCID']+"^"+session['LOGON.USERID']
    }, 
    ColHidden:{
        SelHide:false,
        PatLevel:true,
        CYFlag:true
    },
    DataApi: {
        Msg: function (msgJson) {
            var messageStr = msgJson.message;
            messageArr = messageStr.split('</br>');
            messageStr = messageArr.slice(0, 5).join('</li><li style="padding-left:13px;padding-top:5px;">');
            var msg = '';
            msg += '<div style="line-height:32px">';
            msg += '    <span style="color:#757575;font-weight:bold">总记录:' + msgJson.recordCnt + '</span>';
            msg += '    <span style="padding-left:10px;color:#00B69C;font-weight:bold">成功:' + msgJson.succCnt + '</span>';
            msg += '    <span style="padding-left:10px;color:#FFA804;font-weight:bold">失败:' + msgJson.failCnt + '</span>';
            msg += '</div>';
            msg += '<div style="border-top:1px solid #cccccc;margin-left:-40px;margin-top:10px"></div>';
            msg += '<div style="color:#757575;padding-top:10px;margin-left:-13px">';
            msg += '    <ul style="list-style-type:disc;">';
            msg += '        <li style="padding-left:13px">' + messageStr + '</li>';
            msg += '    </ul>';
            msg += '</div>';
            return msg;
        }
    },
      /**
     * 确认消息框
     * @param {String} _title 标题
     * @param {String} _content 内容
     * @param {String} _callBack 回调
     */
    _Confirm: function (_title, _content, _callBack) {
        if (_title == '') {
            _title = '确认提示';
        }
        $.messager.confirm(_title, _content, function (r) {
            if (r) {
                return _callBack(true);
            } else {
                return _callBack(false);
            }
        });
    },
    _Msg: function (_type, _Msg) {
        return PHA.Popover({
            type: _type,
            msg: _Msg
        });
    },
    _Alert:function(_msg,_msgType,_title,_posi,_fn){
         PHA_COM._Alert(_msg, _msgType)
    },
    PrintDateTime:function(){   
        var d=new Date();
        var pt="";
        var c=":";
        var tmpdate =d.getDate();
        var tmpmonth=d.getMonth()+1;
        if (tmpdate<10){
            tmpdate="0"+tmpdate;
        }
        if (tmpmonth<10){
            tmpmonth="0"+tmpmonth;
        }
        if(PHAOP_COM.PLUGINS.DATEFMT=="DD/MM/YYYY"){
            pt+=tmpdate+"/";    
            pt+=tmpmonth+"/";
            pt+=d.getFullYear();
        }else if (PHAOP_COM.PLUGINS.DATEFMT="YYYY-MM-DD"){
            pt+=d.getFullYear()+"-";    //getYear 改为 getFullYear 20151104zhouyg
            pt+=(d.getMonth()+1)+"-";
            pt+=tmpdate;
        }else{
            pt+=d.getFullYear()+"-";    
            pt+=tmpmonth+"-";
            pt+=tmpdate;
        } 
        pt+=" "
        pt+=d.getHours()+c;
        pt+=d.getMinutes()+c;
        pt+=d.getSeconds();
        return pt
    },
    ExportGrid:function(gridId){
        if((gridId=="")||(gridId==undefined)){return}
        var $grid = $("#"+gridId);
        var rowNum = $grid.datagrid('getData').rows.length;
        if(rowNum == 0){
            PHAOP_COM._Alert("页面没有数据,无需导出!");
            return;
        }
        PHA_COM.ExportGrid(gridId);
    },
    LocalFilter: function (data) {
        var $grid = $(this);
        var opts = $grid.datagrid('options');
        var pager = $grid.datagrid('getPager');
        pager.pagination({
            onSelectPage: function (pageNum, pageSize) {
                opts.pageNumber = pageNum;
                opts.pageSize = pageSize;
                pager.pagination('refresh', {
                    pageNumber: pageNum,
                    pageSize: pageSize
                });
                $grid.datagrid('loading');
                setTimeout(function () {
                    $grid.datagrid('loadData', data);
                }, 100);
            }
        });
        if (!data.originalRows) {
            data.originalRows = data.rows;
        }
        var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
        var end = start + parseInt(opts.pageSize);
        data.rows = data.originalRows.slice(start, end);
        return data;
    },
    /**
     * 窗口卸载时,删除产生的临时数据
     * @param {String} clsName 类名全称
     * @param {String} pid 进程号
     */
    KillTmpOnUnLoad: function (clsName, pid) {
        window.addEventListener('beforeunload', function () {
            tkMakeServerCall('PHA.OP.COM.Base', 'KillTmp', clsName, pid);
        });
    },
    /*  开关窗口
    *   PHAOP_COM.ClearErpMenu();   
    */
    ChangeWinStatus:function(winId,state,obj) {
        if(state){state="1"}
        else{state = "0"}
        var retVal =tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "UpdWinDoFlag",winId,state,PHAOP_COM.LogonData.ALL)
        if(retVal == "0"){
            return;
        }else{
            PHAOP_COM._Alert(retVal);
        }
    },
    /**
    * 控制条件区域的title是否显示
    *   PHAOP_COM.PanelCondition({
    *        body: '#lyBody',               //北div -id
    *        panel: '#panelCondition',      //查询区域id
    *        field: '.pha-con-more-less',   //区域class
    *        heightArr: [135, 215]          //高度(隐藏-显示)
    *    });
    */
    PanelCondition: function (_options) {
        if (PHA_COM.IsTabsMenu() === true) {
            var tmpHeightArr = _options.heightArr;
            for (var i = 0; i < tmpHeightArr.length; i++) {
                tmpHeightArr[i] = tmpHeightArr[i] - 33;
            }
            $(_options.panel).panel({
                title: ''
            });
            $(_options.field + ' div').text('');
            $(_options.body).layout('panel', 'north').panel('resize', { height: tmpHeightArr[0] });
            $(_options.body).layout('resize');
        } else {
            $(_options.panel).panel({});
        }

        var heightArr = _options.heightArr;
        $(_options.field).on('click', function (e) {
            $(_options.field).toggle();
            $(_options.field + '-link').toggle();
            var tHeight = $(_options.field + '-link').css('display') === 'block' ? heightArr[1] : heightArr[0];
            $(_options.body).layout('panel', 'north').panel('resize', { height: tHeight });
            $(_options.body).layout('resize');
        });
    },
    CheckPermission:function(_opt,_fn){
        var flag = _opt.permissionType;
        var noSelWin = _opt.noSelWin || ""; 
        PHA.CM({
            pClassName: 'PHA.OP.COM.Method',
            pMethodName: 'CheckPermission',
            locid: PHA_COM.Session.CTLOCID,
            userid:PHA_COM.Session.USERID,
            groupid:PHA_COM.Session.GROUPID
        },function(data) {
            var retjson =data;
            var retData = retjson[0];
            var permissionmsg = "",
                permissioninfo = "";
            if (retData.phloc == "") {
                permissionmsg = $g("药房科室")+":" + PHAOP_COM.LogonData.LocText;
                permissioninfo = $g("尚未在门诊药房科室配置的人员权限页签中维护")+"!"
            } else {
                permissionmsg = $g("工号")+":" + PHAOP_COM.LogonData.UserCode + "　　"+$g("姓名")+":" + PHAOP_COM.LogonData.UserName;
                if (retData.phuser == "") {
                    permissioninfo = $g("尚未在门诊药房科室配置的人员权限页签中维护")+"!"
                } else if (retData.phnouse == "Y") {
                    permissioninfo = $g("门诊药房科室配置的人员权限页签中已设置为无效")+"!"
                } else if ((flag == "PY")&&(retData.phpy != "Y")) {
                    permissioninfo = $g("门诊药房科室配置的人员权限页签中未设置配药权限")+"!"
                } else if ((flag == "FY")&&(retData.phfy != "Y")) {
                    permissioninfo = $g("门诊药房科室配置的人员权限页签中未设置发药权限")+"!"
                }
            }
            if (permissioninfo != "") {
                    var ret = COMPOMENTS.Window.Open({
                        locId :PHA_COM.Session.CTLOCID,
                        type:"Permission",
                        msg:permissionmsg,
                        info:permissioninfo
                    });
            } else {
                PHAOP_COM.DEFAULT.phlId = retData.phloc;
                PHAOP_COM.DEFAULT.phPerId = retData.phuser;
                PHAOP_COM.DEFAULT.cyFlag = retData.phcy;
                PHAOP_COM.DEFAULT.OweDisp = retData.owedisp;
                PHAOP_COM.DEFAULT.RetNeedReq = retData.ReturnNeedReq;
                PHAOP_COM.DEFAULT.FYCheck = retData.FyCheckDrug;
                if(retData.phcy == "Y") {PHAOP_COM.ColHidden.CYFlag = true;}
                if($("#"+OP_COMPOMENTS.Element.LocDesc).length >0){
                    $("#"+OP_COMPOMENTS.Element.LocDesc).text(PHAOP_COM.LogonData.LocText);
                }
                var getphcookie = PHAOP_COM.GetCookie(PHAOP_COM.COOKIE.NAME + "^" + PHAOP_COM.VAR.WinType);
                if (getphcookie != "") {
                    $("#"+OP_COMPOMENTS.Element.WinDesc).text(getphcookie.split("^")[1]);
                    PHAOP_COM.DEFAULT.winIdStr = getphcookie.split("^")[0];
                    // 直接发药界面--配药人赋值
                    if($("#"+OP_COMPOMENTS.Element.PyPerName).length >0){
                        $("#"+OP_COMPOMENTS.Element.PyPerName).text(getphcookie.split("^")[3]);
                        PHAOP_COM.DEFAULT.phPyPerId = getphcookie.split("^")[2];;
                    }
                    if(_fn){_fn();}
                } else {
                    if(noSelWin == ""){
                        var ret = COMPOMENTS.Window.Open({
                            locId :PHAOP_COM.LogonData.LocId,
                            type:PHAOP_COM.VAR.WinType
                        },_fn)
                    }else{
                        if(_fn){_fn();}
                    }
                }
            }
        },function(failRet){
        }) 
    },
    //@description:setcookie
    SetCookie:function (name, value) {
        var oDate = new Date();
        oDate.setDate(oDate.getDate());
        document.cookie = name + "=" + encodeURIComponent(value) + ";expires=" + oDate;
    },
    //@description:getcookie
    GetCookie:function (name) {
        var cookiearr = document.cookie.split("; ");
        var i = 0;
        for (i = 0; i < cookiearr.length; i++) {
            var cookiearri = cookiearr[i].split("=");
            if (cookiearri[0] == name) {
                var getCookieValue = decodeURIComponent(cookiearri[1]);
                return getCookieValue;
            }
        }
        return "";
    },

    //@description:removecookie
    RemoveCookie:function (name) {
        this.SetCookie(name, "1", -1);
    },
    // 配药窗口确认
    PYWindowConfirm:function() {
        var $grid = $('#'+OP_COMPOMENTS.Window.ComInfo.gridId)
        var timestep = $("#timeStep").val()|| "";
        if (timestep == "") {
             PHAOP_COM._Alert("时间间隔不能为空!");
            return false;
        }
        if ($.trim(timestep) != "") {
            PHAOP_COM.VAR.TIMERSTEP = $("#timeStep").val()*1000;
        }   
        var checkedRows = $grid.datagrid('getChecked');;
        var winDescStr="";
        var winIdStr=""
        var selNum=0
        var len= checkedRows.length;
        for (var i=0;i<len;i++ ) {
            var rowData =checkedRows[i];
            selNum=selNum+1;
            if(winDescStr==""){
                winDescStr=rowData.phwWinDesc;
                winIdStr=rowData.phwid;
            }
            else{
                if(selNum<=3){
                    winDescStr=winDescStr+","+rowData.phwWinDesc;
                }else if(selNum>3){
                    winDescStr=winDescStr+"..";
                }else{
                    winDescStr=winDescStr;
                }
                
                winIdStr=winIdStr+","+rowData.phwid
            }   
        }
        if(winDescStr==""){
            PHAOP_COM._Alert("请选择发药窗口!");
            return false;
        }
        $("#"+OP_COMPOMENTS.Element.WinDesc).text(winDescStr);
        PHAOP_COM.DEFAULT.winIdStr = winIdStr;
        var cookieInfo = winIdStr + "^" + winDescStr;
        this.RemoveCookie(PHAOP_COM.COOKIE.NAME + "^" + PHAOP_COM.VAR.WinType);
        this.SetCookie(PHAOP_COM.COOKIE.NAME + "^" + PHAOP_COM.VAR.WinType, cookieInfo);
        //ClearConditions();
        return true;
    },
    // 发药界面 --窗口确认
    FYWindowConfirm:function() {

        var winDescStr =$("#fyWinId").combobox("getText")
        var winIdStr =$("#fyWinId").combobox("getValue")
        if(winDescStr==""){
            PHAOP_COM._Alert("窗口不能为空!");
            return false;
        }
        $("#"+OP_COMPOMENTS.Element.WinDesc).text(winDescStr);
        PHAOP_COM.DEFAULT.winIdStr = winIdStr;
        var cookieInfo = winIdStr + "^" + winDescStr;
        this.RemoveCookie(PHAOP_COM.COOKIE.NAME + "^" + PHAOP_COM.VAR.WinType);
        this.SetCookie(PHAOP_COM.COOKIE.NAME + "^" + PHAOP_COM.VAR.WinType, cookieInfo);
        //ClearConditions();
        return true;
    },
    // 发药界面 --窗口确认
    DispWindowConfirm:function() {

        var winDescStr =$("#fyWinId").combobox("getText")
        var winIdStr =$("#fyWinId").combobox("getValue")
        if(winDescStr==""){
            PHAOP_COM._Alert("窗口不能为空!");
            return false;
        }
        var pyPerName =$("#pyPerId").combobox("getText")
        var pyPerId =$("#pyPerId").combobox("getValue")
        if(winDescStr==""){
            PHAOP_COM._Alert("窗口不能为空!");
            return false;
        }
        if(pyPerName == ""){
            PHAOP_COM._Alert("请选择配药人!");
            return false;
        }
        $("#"+OP_COMPOMENTS.Element.WinDesc).text(winDescStr);
        $("#"+OP_COMPOMENTS.Element.PyPerName).text(pyPerName);
        PHAOP_COM.DEFAULT.winIdStr = winIdStr;
        PHAOP_COM.DEFAULT.phPyPerId = pyPerId;
        var cookieInfo = winIdStr + "^" + winDescStr + "^" + pyPerId + "^" + pyPerName;
        this.RemoveCookie(PHAOP_COM.COOKIE.NAME + "^" + PHAOP_COM.VAR.WinType);
        this.SetCookie(PHAOP_COM.COOKIE.NAME + "^" + PHAOP_COM.VAR.WinType, cookieInfo);
        //ClearConditions();
        return true;
    },
    // 默认配药窗口
    SetDefWin:function (gridId){
        if(gridId == undefined){gridId == OP_COMPOMENTS.Window.ComInfo.gridId}
        var $grid = $("#"+gridId)
        var rows = $grid.datagrid('getRows');
        if(rows.length<1){return;}
        var winIdStr=PHAOP_COM.DEFAULT.winIdStr
        if(winIdStr!=""){
            var winArr=winIdStr.split(",");
            for (var j = 0; j < winArr.length ; j++) {
                var winId=winArr[j]
                for (var i = 0; i <rows.length; i++) {
                    var rowData = rows[i];
                    var rowWinId = rowData.phwid;
                    if(rowWinId==winId){
                        $grid.datagrid('checkRow', i);
                    }
                }
            }
        }else{
            var localIP = PHAOP_COM.DEFAULT.localIP;
            if((localIP=="")||(localIP==undefined)){return;}
            for (var i = 0; i < rows.length; i++) {
                var rowData = rows[i];
                var rowDefWInIP = rowData.defWinIp;
                if(rowDefWInIP==localIP){
                    $grid.datagrid('checkRow', i);
                }
            }
        }
    },
    /*
    *处方明细显示图片
    *csp需要加载 <csp:Include Page="pha.op.v4.orders.csp">
    *参数_opt     ：params --处方号的JSON串，可以多个处方号
    *                 divImgId  --按图片显示明细时，明细所在div的id
    */
    ShowPrescDetailForImg:function(_opt){
        var pJson = _opt.pJson;
        var divImgId = _opt.divImgId;
        
        var RetJson = PHA.CM({
            pClassName:'PHA.OP.PyAdv.Api' ,
            pMethodName:'GetPrescDetail',
            pPlug:'datagrid',
            pJson: JSON.stringify(pJson)
        },false);
        var previewRows=[];
        var RetData =RetJson.rows
        var rowsLen = RetData.length;
        for (var i = 0; i < rowsLen; i++) {
            var rowData = RetData[i];
            var RealQty=rowData.TRealQty;
            if(RealQty==undefined){
                RealQty=rowData.TPhQty;
            }
            var inciId=rowData.TInci;
            var imgFile = rowData.TDocmentName;
            if((imgFile =="")||(imgFile ==undefined)) {imgFile=""}
            var newRow={
                inciDesc: rowData.TPhDesc,
                qty:RealQty + rowData.TPhUom,
                inciAddInfo:rowData.TPhgg + ' | ' + rowData.TPhFact,
                instrucDesc:rowData.TYF,
                freqDesc:rowData.TPC,
                dosage:rowData.TJL,
                docRemark:rowData.TPhbz,
                invno:rowData.TPrtNo,
                stkbin:rowData.TIncHW,
                saleprice:rowData.TPrice,
                spamt:rowData.TMoney,
                detailstatue:rowData.TPhDispItmStat,
                stkqty:rowData.TKCQty,
                medImg:imgFile  
            }
            previewRows.push(newRow);
        }
        var template = $('#tempOrders').html();
        var handler = Handlebars.compile(template);
        $('#'+divImgId).html(handler({rows:previewRows}));
        
    },
    /*  病历浏览  初始化病人信息(仅就诊id)
    *   勾选列表的情况下，为当前所选记录，非勾选记录
    *   PHAOP_COM.InitErpMenu({prescNo:prescNo});   
    */
    InitErpMenu : function(_opt) {
        var prescNo = _opt.prescNo;
        var frm = dhcsys_getmenuform();
        if (frm) {
            var patAdm = tkMakeServerCall("PHA.OP.COM.Method", "GetAdmIdByPresc", prescNo);
            if (patAdm == "") {
                return;
            }
            frm.EpisodeID.value = patAdm;
        }
    },
    /*  病历浏览  清除病人信息(仅就诊id)
    *   PHAOP_COM.ClearErpMenu();   
    */
    ClearErpMenu:function() {
        var frm = dhcsys_getmenuform();
        if (frm) {
            if (frm.EpisodeID) {
                frm.EpisodeID.value = "";
            }
        }
    },
    //提示未发信息
    ChkUnFyOtherLoc:function(_opt){
        if (APP_PROP.ChkUnDispOtherLoc != "Y") return;
        var stDateId = _opt.stDate || "stDate"
        var endDateId = _opt.endDateId || "endDate"
        var patNoId = _opt.patNo || "patNo";
        var dispType = _opt.dispType || "0";
        var stDate = $("#" + stDateId).datebox("getValue")|| ""; 
        var endDate = $("#" + endDateId).datebox("getValue")|| ""; 
        var patNo = $("#" + patNoId).val();
        if ((patNo == "") || (patNo == null)) {
            return;
        }
        var ret = tkMakeServerCall("PHA.OP.COM.Method", "ChkUnFyOtherLoc", stDate, endDate, patNo, PHAOP_COM.DEFAULT.phlId, PHAOP_COM.DEFAULT.winIdStr ,dispType);
        if (ret == -1) {
            // alert("病人为空,请读卡")
        } else if (ret == -2) {
            PHAOP_COM._Alert("没找到该病人");
            return;

        } else if ((ret != "") && (ret != null)) {
            PHAOP_COM._Alert(ret,"info");
        }
    },
    /**
     * 处方审核拒绝原因选择,内容Load csp,如进入系统已经加载过,则之后不会重复加载
     */
    ShowPHAPRASelReason:function (paramOpts, callBack,origOpts) {
        var reasonURL = "pha.pra.v1.selreason.csp";
        var wayId = paramOpts.wayId || "";
        var oeori = paramOpts.oeori || "";
        var prescNo = paramOpts.prescNo || "";
        var selType = paramOpts.selType || "";
        if (top.$("#PHA_PRA_V1_SELREASON").html() != undefined) {
            top.$("#PHA_PRA_V1_SELREASON").panel("options").onBeforeClose = DoReturn;
            top.$("#PHA_PRA_V1_SELREASON").window("open");
            // 如果不是重新加载,则重新修改内容
            var reasonFrm;
            var frms = top.frames;
            for (var i = frms.length - 1; i >= 0; i--) {
                if (frms[i].TRELOADPAGE == "pha.pra.v1.selreason.csp") {
                    reasonFrm = frms[i];
                    break;
                }
            }
            reasonFrm.PRA_WAYID = wayId;
            reasonFrm.PRA_OEORI = oeori;
            reasonFrm.PRA_PRESCNO = prescNo;
            reasonFrm.PRA_SELTYPE = selType;
            reasonFrm.ReLoadPRASelReason();
            return;
        }
        websys_showModal({
            id: "PHA_PRA_V1_SELREASON",
            url: reasonURL + "?oeori=" + oeori + "&wayId=" + wayId + "&selType=" + selType + "&prescNo=" + prescNo,
            title: "拒绝原因选择与录入",
            iconCls: "icon-w-list",
            width: "80%",
            height: "80%",
            closable: false,
            onClose: function () {}, // 不能去掉,否则默认销毁窗体
            onBeforeClose: DoReturn
        });
        function DoReturn() {
            var reasonStr = "";
            if (top) {
                var reasonFrm;
                var frms = top.frames;
                for (var i = frms.length - 1; i >= 0; i--) {
                    if (frms[i].TRELOADPAGE == "pha.pra.v1.selreason.csp") {
                        reasonFrm = frms[i];
                        break;
                    }
                }
                if (reasonFrm != "") {
                    var reasonStr = reasonFrm.PRA_SELREASON_RET;
                }
            }
            if(reasonStr.indexOf("^")>-1){reasonStr = reasonStr.replace(/\^/g,"!!")}
            callBack(reasonStr, origOpts);
        }
    },
    /*
    *门诊发药接口掉用
    */
    SendOPInfoToMachine:function(_opt){
        var computerIP = ClientIPAddress;
        var userId = session['LOGON.USERID'];
        var locId = session['LOGON.CTLOCID'];
        _opt.phlLocId = locId;
        _opt.IP = computerIP;
        _opt.userId = userId ;
        var retJson = PHA.CM({
                pClassName: 'PHA.OP.COM.Api',
                pMethodName: 'OPInterfaceCom',
                pJson: JSON.stringify(_opt)
        },false);
        var retCode = retJson.code;
        if (retCode < 0) {
            PHAOP_COM._Alert(retJson.msg);
            return false;
        }
        return true;
    },
    CardPayCom:function(_opt, _fn){
        if (_fn == undefined) {
            _fn = "";
        }
        var txtCardType= _opt.cardTypeId;
        var txtCardNo = _opt.cardNoId;
        var txtPatNo = _opt.patNoId;
        var stDate = _opt.stDate;
        var endDate = _opt.endDate;
        
        var cardNo = $("#" + txtCardNo).val();
        var patNo = $("#" + txtPatNo).val();
        var patInfo = tkMakeServerCall("PHA.OP.COM.Method", "GetPatInfoByNo", patNo, session["LOGON.CTLOCID"]);
        if (patInfo == "{}") {
            PHAOP_COM._Alert("该患者无对应卡信息,不能进行预扣费!");
            return false;
        }
        var jsonPatInfo = JSON.parse(patInfo);
        var admStr = jsonPatInfo.admDrStr;
        var lastAdm = jsonPatInfo.lastAdm;
        var papmiDr = jsonPatInfo.papmiDr;
        var cardType = jsonPatInfo.CardType;
        var CardTypeConfig = jsonPatInfo.CardTypeConfig;
        var userId = PHAOP_COM.LogonData.UserId;
        var groupId = PHAOP_COM.LogonData.GroupId;
        var locId = PHAOP_COM.LogonData.LocId;
        var hospId = PHAOP_COM.LogonData.HospId;;
        
        var mode = tkMakeServerCall("PHA.FACE.IN.Com", "GetCheckOutMode", groupId + "^" + locId + "^" + hospId);
        if (mode == 1) {
            if (CardNo == "") {
                PHAOP_COM._Alert("该患者无对应卡信息,不能进行预扣费!");
                return false;
            }
            PHAOP_COM._Confirm("卡消费","是否确认扣费? 点击[确定]生成，点击[取消]退出", function (r) {
                if (r == true) {
                    var insType = "";
                    var oeoriIDStr = "";
                    var cardTypeRowId =$("#" + txtCardType).val() || "";  
                    $("#CardBillCardTypeValue").val(tkMakeServerCall("PHA.FACE.IN.Com", "GetCardTypeInfo", cardTypeRowId));
                    var rtn = checkOut(cardNo, papmiDr, lastAdm, insType, oeoriIDStr, userId, groupId, locId, hospId);
                    if (_fn != "") {
                        setTimeout(function () {
                            _fn()
                        }, 300);;
                    }
                } else {
                    return;
                }
            });
            return;
        } else {
            var cardTypeRowId =$("#" + txtCardType).val() || cardType;  
            var url = "dhcbill.opbill.charge.main.csp?ReloadFlag=3&CardNo=" + cardNo + "&SelectAdmRowId=" + admStr + "&SelectPatRowId=" + papmiDr + "&CardTypeRowId=" + cardTypeRowId;
            websys_showModal({
                url: url,
                title: "预扣费",
                iconCls: "icon-w-inv",
                width: "97%",
                height: "85%",
                onClose: function () {
                    if (_fn != "") {
                        _fn();
                    }
                    var ret = tkMakeServerCall("PHA.FACE.IN.Com", "UnLockOPAdm", admStr, "User.OEOrder");
                    if (top) {
                        top.$(this).window("destroy");
                    }
                }
            });
        }
    },
    // 条码
    DealPrescBarCode:function(_opt){
        var barCodeId = _opt.barCodeId || "";
        if(barCodeId == ""){return ""}
        var barCodeInfo=$("#"+_opt.barCodeId).val();
        if(barCodeInfo==""){return ""}
        var prescNo="";
        var BarCodeData="";
        try {
            var strData = window.atob(barCodeInfo);
            BarCodeData = pako.inflate(strData, {
                to: 'string'
            });
            if (typeof JSON.parse(BarCodeData) == "object") {
                var jsonInfo=JSON.parse(BarCodeData);
                var info=jsonInfo.Info;
                var ArrInfo=info.split("*");
                if(ArrInfo.length>4){
                    prescNo=ArrInfo[3];
                    var payInfo=jsonInfo.PayInfo; 
                    var payFlag=payInfo.split("*")[0];
                    if(payFlag!="P"){
                        return false;
                    }
                }
            }
        } catch(ex) {
            try {
                if (typeof JSON.parse(barCodeInfo) == "object") {
                    var jsonInfo=JSON.parse(barCodeInfo);
                    var info=jsonInfo.Info;
                    var ArrInfo=info.split("*");
                    if(ArrInfo.length>4){
                        prescNo=ArrInfo[3];
                        var payInfo=jsonInfo.PayInfo; 
                        var payFlag=payInfo.split("*")[0];
                        if(payFlag!="P"){
                            return false;
                        }
                    }
                }
            } catch(e) {
                prescNo=barCodeInfo;
            }
        }
        return prescNo;
    },
    PrescTimeLine:function(_opt){
        var prescNo = _opt.prescNo || "";
        var retData = PHA.CM({
                pClassName: 'PHA.OP.DispQuery.Query',
                pQueryName: 'PrescOperRecords',
                inputStr: prescNo
        },false);
        var itemsArr = [];
        var rowsData = retData;
        for (var i = 0; i < rowsData.length; i++) {
            var rowData = rowsData[i];
            var contextArr = [];
            contextArr.push('<div>');
            contextArr.push(rowData.dateTime);
            contextArr.push('</div>');
            contextArr.push('<div>');
            contextArr.push(rowData.userName);
            contextArr.push('</div>');
            var item = {};
            item.title = rowData.psName;
            item.context = contextArr.join('');
            itemsArr.push(item);
        }
        $('.vstep').children().remove();
        $("#"+_opt.timeLine).vstep({
            //showNumber:false,
            stepHeight:70,
            currentInd:rowsData.length,
            onSelect:function(ind,item){console.log(item);},
            //titlePostion:'top',
            items:itemsArr
        });
    },
    CACert:function(_opt, _callback) {
        var modelName = _opt.modelName ||""
        if(modelName == "") modelName =  PHAOP_COM.VAR.CAModelCode; 
        var logonType = ""; // 登录类型，UKEY|PHONE|FACE|SOUND|"" 空时弹出配置签名方式
        var singleLogon = 0; // 是否弹出单登录方式: 0-弹出多页签签名，1-单种签名方式
        var forceOpen = 0; // 强制弹出签名窗口(默认0:没有登录过则弹出，登录过则不弹出;1:强制弹出签名窗口)
        dhcsys_getcacert({
            modelCode: modelName,   //签名模块中代码
            callback: function (cartn) {
                // 签名窗口关闭后,会进入这里
                if (cartn.IsSucc) {
                    if (cartn.ContainerName == "") {
                        _callback(); // CA 未开启
                    } else {
                        if ("object" == typeof cartn && cartn.ContainerName !== '') {
                            PHAOP_COM.CAData = cartn;
                            _callback(); // 写后面的业务代码
                        }
                    }
                } else {
                    alert($g("签名失败！"));
                    return false;
                }
            }
            //isHeaderMenuOpen:true, //是否在头菜单打开签名窗口. 默认true
            //SignUserCode:"YF01",   //期望签名人HIS工号，会校验证书用户与HIS工号. 默认空
            //signUserType:"",   // 默认空，表示签名用户与当前HIS用户一致。ALL时不验证用户与证书
            //notLoadCAJs:1,  //登录成功后，不向头菜单加载CA
            //loc:deptDesc,   //科室id或描述，默认当前登录科室
            //groupDesc:groupDesc,  //安全组描述，默认当前登录安全组
            //caInSelfWindow:1  //用户登录与切换科室功能， 业务组不用
        });
    },
    SaveCACert:function(_opt){
        if(PHAOP_COM.CAData == ""){return;}
        if(APP_COM_PROP.CADataSaveFlag != "Y"){return;}
        var signVal = _opt.signVal;
        var type = _opt.type;
        var modelName = _opt.modelName ||""
        if(modelName == "") modelName =  PHAOP_COM.VAR.CAModelCode; 
        var hashData = PHAOP_COM.CAData.ca_key.HashData(signVal);
        var signData = PHAOP_COM.CAData.ca_key.SignedData(hashData,PHAOP_COM.CAData.ContainerName);
        if (signData ==""){
            return ;
        } else {                          
           var userCertCode = PHAOP_COM.CAData.CAUserCertCode;
           var certNo = PHAOP_COM.CAData.CACertNo;
           var pJson = {
                usrCertCode:userCertCode,
                contentHash:hashData,
                signData:signData,
                code:modelName,     
                certNo:certNo,
                signVal:signVal,
                type:type
           }
        }
        var retData = PHA.CM({
                pClassName: 'PHA.COM.CA.Biz',
                pMethodName: 'SaveCAData',
                pJson: JSON.stringify(pJson)
        },false);
       
    },
    /*
    *显示药品相似时，显示药品信息
    *
    */
    ShowIncEasyCon:function (event, Inci, Type) {
        
        var retData = tkMakeServerCall("PHA.OP.PyDisp.Query", "GetIncEasyCon", Inci, Type);
        var retJSON = eval("(" + retData + ")");
        var infoLen = retJSON.length;
        if (infoLen == 0) {
            return;
        }
        var firstInfo = retJSON[0];
        var inciCode = firstInfo.InciCode;
        var inciDesc = firstInfo.InciDesc;
        var manfDesc = firstInfo.ManfDesc;
        var Spec = firstInfo.Spec;
        var docStr = firstInfo.DocStr; //文件信息
        var imgName = "";
        if (docStr.length > 0) {
            var imgName = docStr[0].DocName;
        }
        var imgSrc=PHAOP_COM.GetHttpFile(imgName) 
        if (imgSrc==""){
            imgSrc = "../scripts_lib/hisui-0.1.0/dist/css/icons/big/paper.png";
        }
        var htmlStr = "";
        htmlStr += '    <div>';
        htmlStr += '        <div style="height:180px;word-break:break-all;" >'; //border-bottom-style:dashed;
        htmlStr += '            <div style="padding-right:5px;float:left">';
        htmlStr += '                <img src=' + imgSrc + ' height="175px" width="130px">';
        htmlStr += '            </div>';
        htmlStr += '            <div>';
        htmlStr += '                <div>';
        htmlStr += '                    <a style="color:black">' + $g("代码") + ':</a>';
        htmlStr += '                    <a style="color:red">' + inciCode + '</a>';
        htmlStr += '                </div>';
        htmlStr += '                <div >';
        htmlStr += '                    <a style="color:black">' + $g("描述") + ':</a>';
        htmlStr += '                    <a style="color:red">' + inciDesc + '</a>';
        htmlStr += '                </div>';
        htmlStr += '                <div >';
        htmlStr += '                    <a style="color:black">' + $g("规格") + ':</a>';
        htmlStr += '                    <a style="color:red">' + Spec + '</a>';
        htmlStr += '                </div>';
        htmlStr += '                <div >';
        htmlStr += '                    <a style="color:black">' + $g("生产企业") + ':</a>';
        htmlStr += '                    <a style="color:red">' + manfDesc + '</a>';
        htmlStr += '                </div>';
        htmlStr += '            </div>';
        htmlStr += '        </div>';
        htmlStr += '    </div>'
        $(event).popover({
            title : "易混信息",
            trigger : "hover",
            placement:"auto-right",
            width:350,
            height:180,
            content : htmlStr
        });
        $(event).popover('show');
    },
    /*隐藏易混信息popover*/
    HideIncEasyCon:function (event) {
        $(event).popover('hide')
    },
    //获取图片路径
    GetHttpFile: function (_name) {
        if (_name == "") {
            return "";
        }
        if (HttpSrc == "") {
            var httpSrc = tkMakeServerCall("PHA.COM.Upload", "GetFtpHttpSrc", PHAOP_COM.LogonData.LocId)
                var httpSrcArr = httpSrc.split("^");
            if (httpSrcArr[0] < 0) {
                return "";
            } else {
                HttpSrc = httpSrcArr[1];
            }
        }
        var httpHref = window.location.href;
        var httpPre = 'http://';
        if (httpHref.indexOf('https') >= 0) {
            httpPre = 'https://';
        }
        var httpSrc = httpPre + HttpSrc + _name;
        return httpSrc;
    },
    //@description 获取病人基本信息,加载信息到指定div
    //@params 医嘱id
    AppendPatBasicInfo:function(_options) {
        var retData = PHAOP_COM.GetPatBasicInfo(_options.inputNo, _options.getType);
        var imageId = "";
        var patSex = retData.patSex;
        if (patSex == $g("女")) {
            imageId = "woman.png";
        } else if (retData.patSex == $g("男")) {
            imageId = "man.png";
        } else {
            imageId = "unknown_gender.png";
        }
        if ($("#patInfo")) {
            $("#patInfo").remove();
        }
        var patName = retData.patName;
        var patAge = retData.patAge;
        if (patName == undefined) {
            return;
        }
        var files = "blue"
        if(typeof HISUIStyleCode=='string') {
            files = HISUIStyleCode
        }
        var path = "../scripts_lib/hisui-0.1.0/dist/css/icons/"+files+"/pat/"+ imageId;
        
        var patNo = retData.patNo;
        var patHtml = ' <div  id="patInfo" style="padding-top:0.3em;">' 
                    + '     <div style="float:right;padding-top:5px;padding-left:5px">'
                    +           patName + '</br>' + patSex + "  "+ patAge 
                    + '     </div>' 
                    + '     <div style="float:right">' 
                    + '         <img src="' +path + '" style="border-radius:35px;height:50px;width:50px">' 
                    + '     </div>' 
                    + ' </div>';
        
        $(_options.id).append(patHtml);
    },
    //@description 获取病人基本信息
    //@params 卡号/登记号 , 类型(登记号:patNo/卡号:cardNo)
    GetPatBasicInfo:function (inputNo, noType) {
        var patInfo = tkMakeServerCall("PHA.OP.COM.Method", "GetPatBasicInfo", inputNo, noType);
        return JSON.parse(patInfo);
    }

};
// 门诊参数调整到公共，后补获取参数
APP_COM_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_COM_NAME)


/*早期的公共方法*/
function NumZeroPadding(inputNum, numLength) {
    if (inputNum == "") {
        return inputNum;
    }
    var inputNumLen = inputNum.length;
    if (inputNumLen > numLength) {
        //$.messager.alert('错误提示',"输入错误！");
        $.messager.alert("提示","输入错误！超过相应长度！", 'info');
        return "";
    }
    for (var i = 0; i < inputNumLen; i++) {
        var para = inputNum[i];
        if (isNaN(para) || para.trim() == "" || String(para).indexOf(".") > -1 || !(parseInt(inputNum) > 0)) {
            $.messager.alert("提示","请输入正确的信息！", 'info');
            return "";
        }
    }
    for (var i = 1; i <= numLength - inputNumLen; i++) {
        inputNum = "0" + inputNum;
    }
    return inputNum;
}

function GetPhaHisCommonParmas() {
    $.ajax({
        type: "POST", //提交方式 post 或者get
        url: "DHCST.COMMONPHA.ACTION.csp?action=GetPhaHisCommonParmas",
        data: "json",
        success: function(data) {
            var jsondata = JSON.parse(data); // data需要双引号
            hisPatNoLen = jsondata[0].patNoLen;
            
        },
        error: function() {
            alert("获取公共参数失败!");
        }
    });
}