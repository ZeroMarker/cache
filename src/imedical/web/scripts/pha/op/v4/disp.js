/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.08.03
 *  Description 直接发药
 */
var COMPOMENTS ={};
PHAOP_COM.VAR.WinType = "Disp";
PHAOP_COM.VAR.PermissionTpe = "FY";
PHAOP_COM.VAR.CAModelCode = "PHAOPExecuteFY";   
PHAOP_COM.VAR.TIMER = "";
PHAOP_COM.VAR.TIMERSTEP = 30 * 1000;
PHAOP_COM.VAR.WayId = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetWayIdByCode", PHAOP_COM.VAR.WayType);
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME)
var CurPatNo = "";      //主要记录是否按人查询，发药
var IfPatNoEnter = false;  // 是否读卡、或登记号回车
$(function () {
    COMPOMENTS = OP_COMPOMENTS;
    CheckPermission();      //  验证人员权限
    InitGridWaitList();     //  处方列表
    InitGridPrescList();    //  处方列表
    InitGridPrescDetail();  //  处方明细
    InitEvent();            //  按钮事件
    ResizePanel();          //  布局调整
    Clean();                //  包含初始化查询条件
    $("#cardNo").imedisabled();
})
function InitEvent(){
    PHA_EVENT.Bind('#btnFind',          'click', function () {QueryPrescList();});
    PHA_EVENT.Bind('#btnReadCard',      'click', function () {ReadCard();});
    
    //切换窗口
    $('#btnChangeWin').on(  'click', ChangeWin);
    //PHA_EVENT.Bind('#btnChangeWin',   'click', function () {ChangeWin();});
    //表格 toolbar
    PHA_EVENT.Bind('#btnDisp',          'click', function () {
        PHAOP_COM.CACert({},ExecuteDisp);
    });
    PHA_EVENT.Bind('#btnRefuse',        'click', function () {ExecuteRefuseDisp();});
    PHA_EVENT.Bind('#btnCancelRefuse',  'click', function () {CancelRefuseDisp();});
    PHA_EVENT.Bind('#btnBaseMedDisp',   'click', function () {BaseMedDisp();});

    PHA_EVENT.Bind('#btnPrintPresc',    'click', function () {PrintHandler("2");});
    PHA_EVENT.Bind('#btnPrintLabel',    'click', function () {PrintHandler("3");});
    PHA_EVENT.Bind('#btnClean',         'click', function () {Clean();});
    PHA_EVENT.Bind('#btnReturn',        'click', function () {Return();});
    PHA_EVENT.Bind('#btnCardPay',       'click', function () {CardPayHandler();});
    
    //待发药列标
    PHA_EVENT.Bind('#btnFresh',             'click', function () {QueryWaitList();});
    
    $('#patNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#patNo").val());
            if (patNo != "") {
                var newPatNo = PHA_COM.FullPatNo(patNo);
                $(this).val(newPatNo);
                if(newPatNo==""){return;}
                IfPatNoEnter = true;
                QueryPrescList();
            }
        }
    });
    //卡号回车事件
    $('#cardNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var cardNo = $.trim($("#cardNo").val());
            if (cardNo != "") {
                IfPatNoEnter = true;
                ReadCard();
            }
        }
    });
        //单机恢复条码 回车事件
    $('#recoverBarCode').on('keypress', function (event) {
        if (window.event.keyCode == "13") {          
            var barCodeInfo = $.trim($("#recoverBarCode").val());
            if (barCodeInfo != "") {                
                QueryPrescList();
            }
        }
    });
    $("#td-recoverBarCode").attr("style","display:none;");
    $('#cesFlag').on("change", function () {
        var val=$(this).checkbox('getValue');
        if ($(this).is(':checked') == true) {
            $("#td-recoverBarCode").attr("style","display:inline-block;");
        }else{
            $("#td-recoverBarCode").attr("style","display:none;");
        }
    });
    // 留观科室
    PHA.ComboBox('emLoc',{
        blurValidValue:true, 
        url: PHAOP_STORE.EMLoc().url
    });
    // 基数科室
    PHA.ComboBox('baseLoc',{
        blurValidValue:true, 
        url: PHAOP_STORE.BaseLoc().url
    });
}
// 布局调整
function ResizePanel(){
    setTimeout(function () {   
        $("#divGridDetail").panel({title:""})
        PHA_COM.ResizePanel({
            layoutId: 'layout-op—grid',
            region: 'east',
            width: 0.2 
        });

        if(APP_PROP.ShowDetailType=="1"){
            ChangShowDetailType();
        }   
        PHA_COM.ResizePanel({
            layoutId: 'layout-op—grid-presc',
            region: 'north',
            height: 0.5 
        });
        
    }, 0);
}
// 初始化查询条件
function InitDefVal(){
    $("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
    $("#endDate").datebox("setValue",'t') ;
}
function InitGridWaitList(){
    COMPOMENTS.WaitGrid("gridWaitList",{
        toolbar : '#gridWaitListBar',
        onSelect : function(rowIndex, rowData) {
            $('#patNo').val(rowData.tbpatid);
            QueryPrescList();
            
        }
    })
}
function InitGridPrescList(){
     COMPOMENTS.PrescListGrid("gridPrescList",{
         columns: COMPOMENTS.Columns.DispMain.Normal(),
         frozenColumns: COMPOMENTS.Columns.DispMain.Frozen(),
         onSelect : function(rowIndex, rowData) {
            QueryPrescDetail();
            var prescNo = rowData.TPrescNo;
            PHAOP_COM.InitErpMenu({prescNo:prescNo});   
        },onCheck : function(rowIndex, rowData) {
            QueryPrescDetail();
        },onUncheck : function(rowIndex, rowData) {
            QueryPrescDetail();
        },onCheckAll : function(rowIndex, rowData) {
            QueryPrescDetail();
        },onUncheckAll : function(rowIndex, rowData) {
            QueryPrescDetail();
        },onLoadSuccess : function(data) {
            if(data.total>0){
                if(IfPatNoEnter == true){
                    PHAOP_COM.SendOPInfoToMachine({
                        faceCode:"105", 
                        prescNo:data.rows[0].TPrescNo, 
                        patNo:data.rows[0].TPmiNo
                    });
                }
                $('#gridPrescList').datagrid("selectRow",0);
            }else{
                $('#gridPrescDetail').datagrid('clear');
                $("#divImg").html("");
            }
            IfPatNoEnter = false;
        },
        loadBeforeClearSelect:true
    })
}
function InitGridPrescDetail(){
    COMPOMENTS.PrescDetailGrid("gridPrescDetail",{
        isCellEdit:true,
        onClickCell: function (index, field, value) {
            if(field != "TRealQty"){return;}
            if (PHAOP_COM.DEFAULT.OweDisp != "Y") {
                return;
            }
            if (PHAOP_COM.DEFAULT.cyFlag == "Y") {
                PHAOP_COM._Msg("info","草药处方，不允许修改");
                return;
            }
            var checkedRows = $("#gridPrescList").datagrid('getChecked');
            if(checkedRows.length>0){
                PHAOP_COM._Msg("info","处方列表勾选情况下，不允许修改");
                return;
            }
            var selRowData = $("#gridPrescList").datagrid('getSelected');
            var fyFlag = selRowData.TFyFlag;
            var dispStat = selRowData.TPhDispStat;
            var canOwe = selRowData.TCanOwe;
            if (fyFlag == "OK") {
                PHAOP_COM._Msg("info","处方已发药，不允许修改");
                return;
            }
            if ((dispStat.indexOf($g("已配")) >= 0) || (dispStat.indexOf($g("已打印")) >= 0)) {
                PHAOP_COM._Msg("info","处方已开始配药，不允许修改")
                return;
            }
            if (canOwe != "Y") {
                PHAOP_COM._Msg("info","处方不符合欠药，不允许修改")
                return;
            }
            PHA_GridEditor.Edit({
                gridID: "gridPrescDetail",
                index: index,
                field: field
            });
        }
    })
}
function GetParams(){
    var prescBarCode =PHAOP_COM.DealPrescBarCode({barCodeId:"recoverBarCode"});  //单机恢复条码(处理后为处方号)
    if(prescBarCode === false){
        PHAOP_COM._Alert("处方未结算!");
         return;
    }
    $("#recoverBarCode").val("");   
    var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
    if(retJson[0] == undefined) {return false;}
    var pJson = {};
    pJson = retJson[0];
    if(PHAOP_COM.DEFAULT.phlId == ""){return false;}
    pJson.prescNo = prescBarCode;
    pJson.phlId = PHAOP_COM.DEFAULT.phlId;
    pJson.winIdStr = PHAOP_COM.DEFAULT.winIdStr;
    pJson.phPerId = PHAOP_COM.DEFAULT.phPerId;
    return pJson;
}
// 查询处方列表
function QueryPrescList(){
    CurPatNo = ""
    PHAOP_COM.ClearErpMenu(); // 清除电子病历菜单需要的参数
    if(!$("#fyFlag").checkbox('getValue'))PHAOP_COM.ChkUnFyOtherLoc({dispType:"1"});
    if((APP_PROP.OnlyDispByPatNo == "Y")){
        var patNo = $("#patNo").val() || ""; 
        var bascLoc =$("#baseLoc").combobox("getValue") || ""; 
        var emLoc =$("#emLoc").combobox("getValue") || ""; 
        var fyFlag = $("#fyFlag").checkbox('getValue');
        var cesFlag = $("#cesFlag").checkbox('getValue');
        var prescNo = $("#prescNo").val() || ""; 
        if((patNo == "")&&(bascLoc == "")&&(emLoc=="")&&(cesFlag != true)&&(fyFlag != true)&&(prescNo =="")){
            PHAOP_COM._Msg("error","请输入留观科室/患者信息后查询!");
            return;
        }
    }
    var pJson = GetParams();
    if(pJson==false){return;}
    $('#gridPrescList').datagrid('clear');
    $('#gridPrescDetail').datagrid('clear');
    CurPatNo = $("#patNo").val();
    var $grid;
    $grid = $("#gridPrescList");
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.DirDisp.Api' ,
        pMethodName:'GetPrescList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
    Setfocus();
}

function ChangShowDetailType(){
    if($("#divImg").css("display")=="none"){
        $("#divTab").css("display","none");
        $("#divImg").css("display","block");
        $("#divImg").css("height",$("#divTab").height());
    }else{
        $("#divTab").css("display","block")
        $("#divImg").css("display","none")
        $("#divImg").css("height",$("#divTab").height())
    }
    QueryPrescDetail();
}
// 查询处方明细
function QueryPrescDetail(){    
    if($("#divImg").css("display")=="none"){
        QueryPrescDetailForTab();
    }else{
        QueryPrescDetailForImg()
    }
}
// 查询处方明细--按图片
function QueryPrescDetailForImg(){
    var checkedRows = $("#gridPrescList").datagrid('getChecked');
    if (checkedRows.length === 0) {
        var selRowData = $("#gridPrescList").datagrid('getSelected');
        if(selRowData == null){return}
        else{
            checkedRows.push(selRowData);
        }
    }
    var phlId = PHAOP_COM.DEFAULT.phlId;;
    var pJson = {};
    var prescArr = [];
    for (var i = 0;i<checkedRows.length;i++) {
        var rowData = checkedRows[i];
        prescArr.push({ 
            phlId   : phlId,
            prescNo : rowData.TPrescNo,
            phdId   : rowData.Tphd           
        });
    }
    pJson.rows = prescArr;
    PHAOP_COM.ShowPrescDetailForImg({
        pJson:pJson,
        divImgId:"divImg"
    })
}
// 查询处方明细--按列表
function QueryPrescDetailForTab(){  
    
    var $grid =  $("#gridPrescDetail");
    var checkedRows = $("#gridPrescList").datagrid('getChecked');
    if (checkedRows.length === 0) {
        var selRowData = $("#gridPrescList").datagrid('getSelected');
        if(selRowData == null){return}
        else{
            checkedRows.push(selRowData);
        }
    }
    var phlId = PHAOP_COM.DEFAULT.phlId;;
    var pJson = {};
    var prescArr = [];
    for (var i =0 ;i<checkedRows.length;i++) {
        var rowData = checkedRows[i];
        prescArr.push({ 
            phlId   : phlId,
            prescNo : rowData.TPrescNo,
            phdId   : rowData.Tphd           
        });
        
    }
    pJson.rows = prescArr;
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.PyAdv.Api' ,
        pMethodName:'GetPrescDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
function QueryWaitList(){
    var $grid =  $("#gridWaitList");
    var pJson = GetParams();
    if(pJson==false){return;}
    pJson.fyType = "1";
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.PyDisp.Api' ,
        pMethodName:'GetNeedFYList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// 清屏
function Clean(){
    PHAOP_COM.ClearErpMenu();
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridPrescList').datagrid('clear');
    $('#gridPrescList').datagrid("uncheckAll")
    $('#gridPrescDetail').datagrid('clear');
    $('#gridWaitList').datagrid('clear');
    $("#divImg").html("");
    InitDefVal();
    QueryWaitList();
    Setfocus();
    CurPatNo = ""
    
}
// 读卡
function ReadCard(){
    PHA_COM.ReadCard({
        CardNoId : "cardNo",
        PatNoId : "patNo"
    },QueryPrescList)

}
// 发药
function ExecuteDisp(){
    var $grid = $("#gridPrescList");
    var rows = $grid.datagrid('getRows');
    if (rows.length ==0) {
        PHAOP_COM._Msg('error', $g("明细没有数据！"));
        return false;
    }
    var chkFlag = ChkBefDisp();
    if(chkFlag == false){return false;}
    var checkedRows = $grid.datagrid('getChecked');
    var retVal ;
    var index;
    var tipMsg = "";
    var dspNum = 0;
    var prescStr = "";
    if (checkedRows.length >0){
        if(checkedRows.length>1) tipMsg = "您已选择多张处方，是否同时发药?"
        else{tipMsg = $g("您通过勾选进行发药，是否发药？")+"<span>"+checkedRows[0].TPrescNo+"</span>"}
        PHAOP_COM._Confirm("发药", tipMsg, function (r) {
            if (r) {    
                var len = checkedRows.length                
                for (var i = 0; i < len;i++) {
                    var rowData = checkedRows[i];
                    index = rows.indexOf(rowData);
                    retVal = CheckPayment(index)
                    if(retVal){
	                    dspNum = dspNum + 1;
                        if (prescStr=="")prescStr = rowData.TPrescNo;
                        else{prescStr = prescStr + "," + rowData.TPrescNo;}
                    }
                }
                if(dspNum>0){ChkUnFyThisLoc(dspNum)}
                QueryWaitList();
                Setfocus();
            } 
        });

    }else{
        var rowData = $grid.datagrid('getSelected');
        if(rowData != null){
            index = $grid.datagrid('getRowIndex',rowData)
            retVal =  CheckPayment(index);
            if(retVal){
                prescStr = rowData.TPrescNo;
                dspNum = 1;
            }
        }else{
            PHAOP_COM._Msg('error', "请选择发药数据！");    
        }
        if(dspNum>0){ChkUnFyThisLoc(dspNum)}
        QueryWaitList();
        Setfocus();
    }   
}

/// 是否可以发药
function ChkBefDisp(){
    var $grid = $("#gridPrescList");
    var checkedRows = $grid.datagrid('getChecked');
    var patNum = 0;
    var tmpPatNo = "";
    var patNo = "";
    var fyFlag =""
    if (checkedRows.length >0){
        for (var i =0;i<checkedRows.lnegth;i++) {
            var rowData = checkedRows[i];
            fyFlag = rowData.TFyFlag;
            patNo = rowData.TPmiNo;
            if(fyFlag == "OK"){
                PHAOP_COM._Msg('error', "<span>" +rowData.TPrescNo+"<span>"+$g("已发药！"));
                return false;
            }
            if(APP_PROP.OnlyDispByPatNo == "Y"){
                if((tmpPatNo != "")&&(tmpPatNo != patNo)){
                    PHAOP_COM._Msg('error', "按设置，不允许多患者同时发药!");
                    return false;
                }
            }
            tmpPatNo = patNo        
        }
    }else{
        var rowData = $grid.datagrid('getSelected');
        if(rowData != null){
            fyFlag = rowData.TFyFlag;
            if(fyFlag == "OK"){
                PHAOP_COM._Msg('error', "<span>"+rowData.TPrescNo+"</span>"+$g("已发药！"));
                return false;
            }
        }else{
            PHAOP_COM._Msg('error', "请选择发药数据！");
            return false;           
        }
    }
    return true;
}

// 获取欠药数量--勾选无欠药数量。
function GetOrdQtyStr(){
    //图片展示方式，不欠药
    if($("#divImg").css("display")!="none"){return ""}
    var $grid = $("#gridPrescList");
    var checkedRows = $grid.datagrid('getChecked');
    if(checkedRows.length > 0){return ""}
    //如果不是勾选发药，那就是选中记录发药
    // 不可以欠药
    if(PHAOP_COM.DEFAULT.OweDisp != "Y"){return ""}
    var rowData = $grid.datagrid('getSelected');
    var prescNo = rowData.TPrescNo;
    var detailData = $("#gridPrescDetail").datagrid("getRows");
    var chkFlag = 0;        //是否有需要欠药记录
    var allowe = 1;         //
    var zeroFlag = 0;       //是否有需发药记录  
    var rowsDispQtyStr = 0
    for (var rowi = 0; rowi < detailData.length; rowi++) {
        var detailPrescNo = detailData[rowi].TPrescNo;
        if(detailPrescNo != prescNo){
            PHAOP_COM._Alert("药品详细列表非本处方数据,请重新选中处方!");
            return false
        }
        var oeoriQty =  $.trim(detailData[rowi].TPhQty);
        var realQty =  $.trim(detailData[rowi].TRealQty);
        if (parseFloat(realQty) > 0) {
            var zeroFlag = 1;
        }
        if(realQty < 0){
            PHAOP_COM._Alert("实发数量不能小于0!");
            return false
        }
        if (parseFloat(realQty) > parseFloat(oeoriQty)) {
            PHAOP_COM._Alert("实发数量不能大于医嘱数量!");
            return false;
        }
        var reg = /^[0-9]\d*$/;
        if (!reg.test(parseFloat(realQty))) {
            PHAOP_COM._Alert("实发数量只能为整数!")
            return false;
        }
        if (parseFloat(realQty) != parseFloat(oeoriQty)) {
            chkFlag = "1";
        }
        if (allowe != 0) {
            allowe = 0
        }
        var ordItm = detailData[rowi].TOrditm
        var uomId = detailData[rowi].TUnit
        var inci = detailData[rowi].TInci
        var tmpDispString = ordItm + "," + realQty + "," + oeoriQty + "," + uomId + "," + inci
        if (rowsDispQtyStr == 0) {
            rowsDispQtyStr = tmpDispString
        } else {
            rowsDispQtyStr = rowsDispQtyStr + "!!" + tmpDispString
        }

    }
    if (zeroFlag != 1) {
        PHAOP_COM._Alert("实发数量不能都为0!");
        return false;
    }
    dispQtyStr = chkFlag + "&&" + allowe + "&&" + rowsDispQtyStr;
    return dispQtyStr;
}
// 发药
function Dispening(index){
    //嵌入欠药程序
    var dispQtyStr = GetOrdQtyStr()
    if(dispQtyStr == undefined ){return false}
    if(dispQtyStr === false){return false}
    var chkFlag = dispQtyStr.split("&&")[0];
    var $grid = $("#gridPrescList");
    var rowData = $grid.datagrid("getRows")[index];
    var prescNo = rowData.TPrescNo;
    if (chkFlag == "1") {
        PHAOP_COM._Confirm("","<span>"+prescNo+"</span>"+$g("是否需要生成欠药单? 点击[确定]生成，点击[取消]退出"), function (r) {
            if (r == true) {
                var retVal = HandlerDisp(index,dispQtyStr)
                return retVal
            } else {
                return false;
            }
        });
    } else {
        var retVal = HandlerDisp(index,dispQtyStr)
        return retVal
    }
}
function HandlerDisp(index,dispQtyStr){
    var $grid = $("#gridPrescList");
    var rowData = $grid.datagrid("getRows")[index];
    var prescNo = rowData.TPrescNo;
    var pJson ={
        phlId : PHAOP_COM.DEFAULT.phlId,
        winIdStr : PHAOP_COM.DEFAULT.winIdStr,
        fyPerId : PHAOP_COM.DEFAULT.phPerId,
        pyPerId : PHAOP_COM.DEFAULT.phPyPerId,
        prescNo : prescNo,
        dispQtyStr:dispQtyStr
    }
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.DirDisp.Api',
        pMethodName: 'SaveDispData',
        pJson: JSON.stringify(pJson)
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        var phdId = retVal.data;
        var updData = {
            TFyFlag : "OK",
            Tphd : phdId,
            TPhDispStat:"已发药"
        }   
        $grid.datagrid('updateRowData', {
            index: index,
            row: updData
        });
        $grid.datagrid('refreshRow', index)
        OP_PRINTCOM.PrintPrescHandler({
            prescNo:prescNo,
            prtType:APP_PROP["Disp.PrintType"],
            phdId:phdId,
            rePrint:"",
            defPrintorFlag:""
        })
        //欠药单打印
        var phOweId=tkMakeServerCall("PHA.OP.COM.Print","GetPhOweByPhd",phdId);
        OP_PRINTCOM.PrintPhdOwe(phOweId);
        
        PHAOP_COM.SendOPInfoToMachine({
            faceCode:"104,108,110", 
            prescNo:prescNo, 
            patNo:rowData.TPmiNo
        }); //104发药灭灯 108发药时下屏 110发送机(处方状态)
        PHAOP_COM.SaveCACert({
            signVal:phdId,
            type:"F"
        })
        return true;
    }else{
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
}
// 拒绝发药
function ExecuteRefuseDisp(){
    var $grid = $("#gridPrescList");
    var rowData = $grid.datagrid('getSelected');
    if(rowData == null){
        PHAOP_COM._Msg("error", "没有需拒绝发药的记录");
        return;
    }
    var phdStat = rowData.TPhDispStat;
    if(phdStat.indexOf($g("已发药"))>-1){
        PHAOP_COM._Msg("error", "处方已发药，不允许拒绝发药");
        return;
    }
    var auditStat = rowData.TDocSS;
    if(auditStat.indexOf($g("拒绝发药"))>-1){
        PHAOP_COM._Msg("error", "处方已拒绝发药，不需要再次拒绝发药");
        return;
    }
    var prescNo = rowData.TPrescNo;
    PHAOP_COM.ShowPHAPRASelReason({
        wayId: PHAOP_COM.VAR.WayId,
        oeori: "",
        prescNo: prescNo,
        selType: "PRESCNO"
    }, SaveCommontResultEX, {
        prescNo: prescNo
    }); 
}
function SaveCommontResultEX(reasonStr, origOpts) {
    var $grid = $("#gridPrescList");
    if (reasonStr == "") {
        return "";
    }
    var prescNo = origOpts.prescNo
    var retArr = reasonStr.split("@");
    var ret = "N";
    var reasonDr = retArr[0];
    var adviceTxt = retArr[2];
    var facTxt = retArr[1];
    var phNote = retArr[3];
    if (reasonDr.indexOf("$$$") == "-1") {
        reasonDr = reasonDr + "$$$" + prescNo;
    }
    var pJson = {
        prescNo : prescNo,
        reasonDr : reasonDr,
        auditFlag :ret,
        userId :PHAOP_COM.LogonData.UserId,
        adviceTxt:adviceTxt,
        facTxt:facTxt,
        phNote:phNote,
        groupId : PHAOP_COM.LogonData.GroupId,
        wayType :"OR"
    }
    var rowData = $grid.datagrid('getSelected');
    var selIndex = $grid.datagrid('getRowIndex',rowData);//获取行号

    var retVal = PHA.CM({
        pClassName: 'PHA.OP.COM.Api',
        pMethodName: 'SaveOPAuditResult',
        pJson: JSON.stringify(pJson)
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        var updData = {
            TDocSS : $g("拒绝发药")
        }   
        $grid.datagrid('updateRowData', {
            index: selIndex,
            row: updData
        });
    } else {
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
}
// 取消拒绝发药
function CancelRefuseDisp(){
    var $grid = $("#gridPrescList");
    var rowData = $grid.datagrid('getSelected');
    if(rowData == null){return}
    var selIndex = $grid.datagrid('getRowIndex',rowData);//获取行号
    var prescNo = rowData.TPrescNo;
    var pJson = {
        prescNo : prescNo,
        wayType:"OR",
        userId :PHAOP_COM.LogonData.UserId
    }
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.COM.Api',
        pMethodName: 'CancelRefuse',
        pJson: JSON.stringify(pJson)
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        var auditInfo = retVal.data;
        var updData = {
            TDocSS : auditInfo
        }   
        $grid.datagrid('updateRowData', {
            index: selIndex,
            row: updData
        });
    } else {
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
    
}
// 打印
function PrintHandler(type){
    var $grid = $("#gridPrescList");
    var checkedRows = $grid.datagrid('getChecked');
    if (checkedRows.length >0){
        for (var i = 0;i < checkedRows.length;i ++) {
            var rowData = checkedRows[i];
            RePrint(rowData,type)
        }
    }else{
        var rowData = $grid.datagrid('getSelected');
        if(rowData != null){
            RePrint(rowData,type)
        }else{
            PHAOP_COM._Msg('error', "请选择打印数据！");
            return false;           
        }
    }
    return true;
}
function RePrint(rowData,type){
    OP_PRINTCOM.PrintPrescHandler({
        prescNo:rowData.TPrescNo,
        prtType:type,
        phdId:rowData.Tphd,
        rePrint:"(补)"
    })
}
/// 基数药发药
function BaseMedDisp(){
    var lnk = "pha.op.v4.basemeddisp.csp";
    websys_createWindow(lnk, $g("基数药发药"), "width=95%,height=75%")
}
// 退药
function Return(){
    var lnk = "pha.op.v4.return.csp";
    websys_createWindow(lnk, $g("退药"), "width=95%,height=75%")
}
// 卡消费
function CardPayHandler(){
    PHA_COM.ReadCard({
        CardTypeId: "cardType",
        CardNoId : "cardNo",
        PatNoId : "patNo"
    },CardPay)
}
function CardPay(){
    var stDate = $("#stDate").datebox("getValue");
    var endDate = $("#endDate").datebox("getValue");
    var _payOpt = {
         cardTypeId: "cardType",
         cardNoId : "cardNo",
         patNoId : "patNo",
         stDate:stDate,
         endDate:endDate
     }  
     PHAOP_COM.CardPayCom(_payOpt,QueryPrescList);  
 }
// 切换窗口
function ChangeWin(){   
    var ret = COMPOMENTS.Window.Open({
        locId :PHA_COM.Session.CTLOCID,
        type:PHAOP_COM.VAR.WinType
    },Clean)
    
}
// 人员权限
function CheckPermission(){
    if(LoadOrdItmId==""){
        PHAOP_COM.CheckPermission({
            permissionType:PHAOP_COM.VAR.PermissionTpe
        },Clean)
    }else{
        InitBodyStyle()
        PHAOP_COM.CheckPermission({
            permissionType:PHAOP_COM.VAR.PermissionTpe
        },QueryPrescList)
    }
}
// 查询or配药后光标位置
function Setfocus()
{
    $("#patNo").val("");
    $("#cardNo").val("");
    if($("#cesFlag").checkbox('getValue')){
        $('#prescNo').focus();
        return;
    }
    if(APP_PROP.FocusFlag == 1){
        $('#cardNo').focus();
    }
    else{
        $('#patNo').focus();
    }
}

/* 检查收费情况 */
function CheckPayment(index){
    var $grid = $("#gridPrescList");
    var rowData = $grid.datagrid("getRows")[index];
    var prescNo = rowData.TPrescNo
    var pJson = {
        prescNo : prescNo,
    }

    //获取处方中的未交费医嘱信息 
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.COM.Api',
        pMethodName: 'GetUnPaidInfo',
        pJson: JSON.stringify(pJson)
    },false);
    var unPaidInfo = retVal.data;
    var retFlag;
        /* 存在未交费时是否允许发药 */
    if (unPaidInfo !== ""){
        if (APP_PROP.PartPiedDispFlag == "Y") {
            retFlag = Dispening(index); 
            return retFlag;
        }
        else {
            PHAOP_COM._Alert("<span>"+ prescNo + "</span>" + $g("存在未交费的医嘱明细,禁止发药!医嘱名称为:") + "<br/>" + unPaidInfo)
            return false;
        }
    }
    else{
        retFlag = Dispening(index); 
        return retFlag  
    }   
}
function ChkUnFyThisLoc(dspPrescNum){
    if((APP_PROP.ChkUnDispPrescNum != "Y")&&(APP_PROP.TipDispPrescNum != "Y")){return}
    var patNo = CurPatNo;
    var $grid = $("#gridPrescList");

    if(dspPrescNum != 1){
        var rowsData = $grid.datagrid('getRows');
        var rowNum = rowsData.length;    
        var successNum=0;
        for (var rowi = 0; rowi < rowNum; rowi++) {
            rowData = rowsData[rowi]
            var okFlag = rowData.TFyFlag;        
            if(okFlag == "OK")successNum = successNum + 1
        }
        dspPrescNum = successNum;
    }
    var alertMsg = "";
    var tipDispNum = "";
    tipDispNum = $g("此次发药处方数：")+ "<span>" + dspPrescNum + "</span>"; 
    
    if (patNo!=""){
        if(APP_PROP.ChkUnDispPrescNum == "Y"){
            var phlId=PHAOP_COM.DEFAULT.phlId;
            var winId = PHAOP_COM.DEFAULT.winIdStr;
            var stDate = $("#stDate").datebox("getValue")|| ""; 
            var endDate = $("#endDate").datebox("getValue")|| ""; 

            var unDspNum=tkMakeServerCall("PHA.OP.COM.Method","ChkUnFyThisLoc",stDate,endDate,patNo,phlId)
            var otherLocRet=tkMakeServerCall("PHA.OP.COM.Method","ChkUnFyOtherLoc",stDate,endDate,patNo,phlId,winId)
            if (unDspNum < 0) unDspNum=0
            if (unDspNum > 0) { 
                var prescNum = parseInt(unDspNum) + dspPrescNum;
                alertMsg= $g("该患者当前药房共缴费待发处方数：")+prescNum;
                if(tipDispNum != "")  alertMsg = alertMsg + "</br>" + tipDispNum
                alertMsg = alertMsg + "</br>" + $g("待发处方数：")+unDspNum
                if (otherLocRet!="") alertMsg=alertMsg +"</br>"+otherLocRet
            }else if (otherLocRet!="") {
                alertMsg = otherLocRet;
            }
        }
    }
    if((alertMsg == "")&&(APP_PROP.TipDispPrescNum == "Y")){
        alertMsg =  tipDispNum;
    }
    
    if(alertMsg == "") return;
    PHAOP_COM._Alert(alertMsg,"info")
}


/**拒绝发药申诉用到的界面初始化***/
function InitBodyStyle() {
    if (LoadPatNo != "") {
            InitParams();
            $("#patNo").val(LoadPatNo);
    }
}
function InitParams(){
    if(LoadOrdItmId==""){return;}
    var retVal=tkMakeServerCall("PHA.COM.Method","GetOrdItmInfoForTipMess",LoadOrdItmId,PHAOP_COM.LogonData.UserId,PHAOP_COM.LogonData.LocId);
    if(retVal!="{}"){
        var retJson=JSON.parse(retVal)
        var ordDate=retJson.ordDate;
        $("#stDate").datebox("setValue",ordDate);
        $("#endDate").datebox("setValue",ordDate);
        var winId=retJson.winId;
        var winDesc=retJson.winDesc;
        var perId=retJson.perId;
        var perName=retJson.perName;
        if((winId !="")&&(perId !="" )){
            var cookieInfo = winId + "^" + winDesc + "^" + perId + "^" + perName;
            PHAOP_COM.RemoveCookie(PHAOP_COM.COOKIE.NAME + "^" + PHAOP_COM.VAR.WinType);
            PHAOP_COM.SetCookie(PHAOP_COM.COOKIE.NAME + "^" + PHAOP_COM.VAR.WinType, cookieInfo);
        }
    
    }
}