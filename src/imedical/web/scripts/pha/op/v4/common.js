// 
var APP_PROP = [];
var APP_COM_PROP = [];
var PHAOP_COM = {
    APP_NAME:"DHCSTOUTPH",
    APP_COM_NAME:"DHCSTCOMMON",
    CAData:"",
    PLUGINS:{
        DATEFMT:"#(DHCPHADATEFMT)#",                    // DHCPHA_CONSTANT.PLUGINS.DATEFMT      ϵͳ�������ڸ�ʽ
        RAFMT:"#(DHCPHARAFMT)#",                        // DHCPHA_CONSTANT.PLUGINS.RAFMT        ϵͳ���۽��λ��
        SAFMT:"#(DHCPHASAFMT)#"                         // DHCPHA_CONSTANT.PLUGINS.SAFMT        ϵͳ�ۼ۽��λ��
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
        phPyPerId:"",       //ֱ�ӷ�ҩ����ҩ��
        phPerId:"",         //��¼��Ӧ�Ĳ�����
        phlId : "",
        winIdStr : "",
        cyFlag : "",        //��ҩ��ʶ
        OweDisp : "",       //Ƿҩ��ҩ
        RetNeedReq:"",      //��ҩ����ҩ����
        FYCheck:"",             //��ҩ�˶�
        StDate:"t-3"
    },
    VAR:{
        TIMER:"",
        TIMERSTEP:"",
        WinType:"",
        WayType:"OR",
        WayId:"",  //�ܾ�����
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
            msg += '    <span style="color:#757575;font-weight:bold">�ܼ�¼:' + msgJson.recordCnt + '</span>';
            msg += '    <span style="padding-left:10px;color:#00B69C;font-weight:bold">�ɹ�:' + msgJson.succCnt + '</span>';
            msg += '    <span style="padding-left:10px;color:#FFA804;font-weight:bold">ʧ��:' + msgJson.failCnt + '</span>';
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
     * ȷ����Ϣ��
     * @param {String} _title ����
     * @param {String} _content ����
     * @param {String} _callBack �ص�
     */
    _Confirm: function (_title, _content, _callBack) {
        if (_title == '') {
            _title = 'ȷ����ʾ';
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
            pt+=d.getFullYear()+"-";    //getYear ��Ϊ getFullYear 20151104zhouyg
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
            PHAOP_COM._Alert("ҳ��û������,���赼��!");
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
     * ����ж��ʱ,ɾ����������ʱ����
     * @param {String} clsName ����ȫ��
     * @param {String} pid ���̺�
     */
    KillTmpOnUnLoad: function (clsName, pid) {
        window.addEventListener('beforeunload', function () {
            tkMakeServerCall('PHA.OP.COM.Base', 'KillTmp', clsName, pid);
        });
    },
    /*  ���ش���
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
    * �������������title�Ƿ���ʾ
    *   PHAOP_COM.PanelCondition({
    *        body: '#lyBody',               //��div -id
    *        panel: '#panelCondition',      //��ѯ����id
    *        field: '.pha-con-more-less',   //����class
    *        heightArr: [135, 215]          //�߶�(����-��ʾ)
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
                permissionmsg = $g("ҩ������")+":" + PHAOP_COM.LogonData.LocText;
                permissioninfo = $g("��δ������ҩ���������õ���ԱȨ��ҳǩ��ά��")+"!"
            } else {
                permissionmsg = $g("����")+":" + PHAOP_COM.LogonData.UserCode + "����"+$g("����")+":" + PHAOP_COM.LogonData.UserName;
                if (retData.phuser == "") {
                    permissioninfo = $g("��δ������ҩ���������õ���ԱȨ��ҳǩ��ά��")+"!"
                } else if (retData.phnouse == "Y") {
                    permissioninfo = $g("����ҩ���������õ���ԱȨ��ҳǩ��������Ϊ��Ч")+"!"
                } else if ((flag == "PY")&&(retData.phpy != "Y")) {
                    permissioninfo = $g("����ҩ���������õ���ԱȨ��ҳǩ��δ������ҩȨ��")+"!"
                } else if ((flag == "FY")&&(retData.phfy != "Y")) {
                    permissioninfo = $g("����ҩ���������õ���ԱȨ��ҳǩ��δ���÷�ҩȨ��")+"!"
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
                    // ֱ�ӷ�ҩ����--��ҩ�˸�ֵ
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
    // ��ҩ����ȷ��
    PYWindowConfirm:function() {
        var $grid = $('#'+OP_COMPOMENTS.Window.ComInfo.gridId)
        var timestep = $("#timeStep").val()|| "";
        if (timestep == "") {
             PHAOP_COM._Alert("ʱ��������Ϊ��!");
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
            PHAOP_COM._Alert("��ѡ��ҩ����!");
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
    // ��ҩ���� --����ȷ��
    FYWindowConfirm:function() {

        var winDescStr =$("#fyWinId").combobox("getText")
        var winIdStr =$("#fyWinId").combobox("getValue")
        if(winDescStr==""){
            PHAOP_COM._Alert("���ڲ���Ϊ��!");
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
    // ��ҩ���� --����ȷ��
    DispWindowConfirm:function() {

        var winDescStr =$("#fyWinId").combobox("getText")
        var winIdStr =$("#fyWinId").combobox("getValue")
        if(winDescStr==""){
            PHAOP_COM._Alert("���ڲ���Ϊ��!");
            return false;
        }
        var pyPerName =$("#pyPerId").combobox("getText")
        var pyPerId =$("#pyPerId").combobox("getValue")
        if(winDescStr==""){
            PHAOP_COM._Alert("���ڲ���Ϊ��!");
            return false;
        }
        if(pyPerName == ""){
            PHAOP_COM._Alert("��ѡ����ҩ��!");
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
    // Ĭ����ҩ����
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
    *������ϸ��ʾͼƬ
    *csp��Ҫ���� <csp:Include Page="pha.op.v4.orders.csp">
    *����_opt     ��params --�����ŵ�JSON�������Զ��������
    *                 divImgId  --��ͼƬ��ʾ��ϸʱ����ϸ����div��id
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
    /*  �������  ��ʼ��������Ϣ(������id)
    *   ��ѡ�б������£�Ϊ��ǰ��ѡ��¼���ǹ�ѡ��¼
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
    /*  �������  ���������Ϣ(������id)
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
    //��ʾδ����Ϣ
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
            // alert("����Ϊ��,�����")
        } else if (ret == -2) {
            PHAOP_COM._Alert("û�ҵ��ò���");
            return;

        } else if ((ret != "") && (ret != null)) {
            PHAOP_COM._Alert(ret,"info");
        }
    },
    /**
     * ������˾ܾ�ԭ��ѡ��,����Load csp,�����ϵͳ�Ѿ����ع�,��֮�󲻻��ظ�����
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
            // ����������¼���,�������޸�����
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
            title: "�ܾ�ԭ��ѡ����¼��",
            iconCls: "icon-w-list",
            width: "80%",
            height: "80%",
            closable: false,
            onClose: function () {}, // ����ȥ��,����Ĭ�����ٴ���
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
    *���﷢ҩ�ӿڵ���
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
            PHAOP_COM._Alert("�û����޶�Ӧ����Ϣ,���ܽ���Ԥ�۷�!");
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
                PHAOP_COM._Alert("�û����޶�Ӧ����Ϣ,���ܽ���Ԥ�۷�!");
                return false;
            }
            PHAOP_COM._Confirm("������","�Ƿ�ȷ�Ͽ۷�? ���[ȷ��]���ɣ����[ȡ��]�˳�", function (r) {
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
                title: "Ԥ�۷�",
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
    // ����
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
        var logonType = ""; // ��¼���ͣ�UKEY|PHONE|FACE|SOUND|"" ��ʱ��������ǩ����ʽ
        var singleLogon = 0; // �Ƿ񵯳�����¼��ʽ: 0-������ҳǩǩ����1-����ǩ����ʽ
        var forceOpen = 0; // ǿ�Ƶ���ǩ������(Ĭ��0:û�е�¼���򵯳�����¼���򲻵���;1:ǿ�Ƶ���ǩ������)
        dhcsys_getcacert({
            modelCode: modelName,   //ǩ��ģ���д���
            callback: function (cartn) {
                // ǩ�����ڹرպ�,���������
                if (cartn.IsSucc) {
                    if (cartn.ContainerName == "") {
                        _callback(); // CA δ����
                    } else {
                        if ("object" == typeof cartn && cartn.ContainerName !== '') {
                            PHAOP_COM.CAData = cartn;
                            _callback(); // д�����ҵ�����
                        }
                    }
                } else {
                    alert($g("ǩ��ʧ�ܣ�"));
                    return false;
                }
            }
            //isHeaderMenuOpen:true, //�Ƿ���ͷ�˵���ǩ������. Ĭ��true
            //SignUserCode:"YF01",   //����ǩ����HIS���ţ���У��֤���û���HIS����. Ĭ�Ͽ�
            //signUserType:"",   // Ĭ�Ͽգ���ʾǩ���û��뵱ǰHIS�û�һ�¡�ALLʱ����֤�û���֤��
            //notLoadCAJs:1,  //��¼�ɹ��󣬲���ͷ�˵�����CA
            //loc:deptDesc,   //����id��������Ĭ�ϵ�ǰ��¼����
            //groupDesc:groupDesc,  //��ȫ��������Ĭ�ϵ�ǰ��¼��ȫ��
            //caInSelfWindow:1  //�û���¼���л����ҹ��ܣ� ҵ���鲻��
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
    *��ʾҩƷ����ʱ����ʾҩƷ��Ϣ
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
        var docStr = firstInfo.DocStr; //�ļ���Ϣ
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
        htmlStr += '                    <a style="color:black">' + $g("����") + ':</a>';
        htmlStr += '                    <a style="color:red">' + inciCode + '</a>';
        htmlStr += '                </div>';
        htmlStr += '                <div >';
        htmlStr += '                    <a style="color:black">' + $g("����") + ':</a>';
        htmlStr += '                    <a style="color:red">' + inciDesc + '</a>';
        htmlStr += '                </div>';
        htmlStr += '                <div >';
        htmlStr += '                    <a style="color:black">' + $g("���") + ':</a>';
        htmlStr += '                    <a style="color:red">' + Spec + '</a>';
        htmlStr += '                </div>';
        htmlStr += '                <div >';
        htmlStr += '                    <a style="color:black">' + $g("������ҵ") + ':</a>';
        htmlStr += '                    <a style="color:red">' + manfDesc + '</a>';
        htmlStr += '                </div>';
        htmlStr += '            </div>';
        htmlStr += '        </div>';
        htmlStr += '    </div>'
        $(event).popover({
            title : "�׻���Ϣ",
            trigger : "hover",
            placement:"auto-right",
            width:350,
            height:180,
            content : htmlStr
        });
        $(event).popover('show');
    },
    /*�����׻���Ϣpopover*/
    HideIncEasyCon:function (event) {
        $(event).popover('hide')
    },
    //��ȡͼƬ·��
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
    //@description ��ȡ���˻�����Ϣ,������Ϣ��ָ��div
    //@params ҽ��id
    AppendPatBasicInfo:function(_options) {
        var retData = PHAOP_COM.GetPatBasicInfo(_options.inputNo, _options.getType);
        var imageId = "";
        var patSex = retData.patSex;
        if (patSex == $g("Ů")) {
            imageId = "woman.png";
        } else if (retData.patSex == $g("��")) {
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
    //@description ��ȡ���˻�����Ϣ
    //@params ����/�ǼǺ� , ����(�ǼǺ�:patNo/����:cardNo)
    GetPatBasicInfo:function (inputNo, noType) {
        var patInfo = tkMakeServerCall("PHA.OP.COM.Method", "GetPatBasicInfo", inputNo, noType);
        return JSON.parse(patInfo);
    }

};
// ��������������������󲹻�ȡ����
APP_COM_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_COM_NAME)


/*���ڵĹ�������*/
function NumZeroPadding(inputNum, numLength) {
    if (inputNum == "") {
        return inputNum;
    }
    var inputNumLen = inputNum.length;
    if (inputNumLen > numLength) {
        //$.messager.alert('������ʾ',"�������");
        $.messager.alert("��ʾ","������󣡳�����Ӧ���ȣ�", 'info');
        return "";
    }
    for (var i = 0; i < inputNumLen; i++) {
        var para = inputNum[i];
        if (isNaN(para) || para.trim() == "" || String(para).indexOf(".") > -1 || !(parseInt(inputNum) > 0)) {
            $.messager.alert("��ʾ","��������ȷ����Ϣ��", 'info');
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
        type: "POST", //�ύ��ʽ post ����get
        url: "DHCST.COMMONPHA.ACTION.csp?action=GetPhaHisCommonParmas",
        data: "json",
        success: function(data) {
            var jsondata = JSON.parse(data); // data��Ҫ˫����
            hisPatNoLen = jsondata[0].patNoLen;
            
        },
        error: function() {
            alert("��ȡ��������ʧ��!");
        }
    });
}