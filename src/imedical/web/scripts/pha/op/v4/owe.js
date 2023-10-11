/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.08.26
 *  Description 门诊欠药管理
 */
var COMPOMENTS ={};
PHAOP_COM.VAR.WinType = "Owe";
PHAOP_COM.VAR.PermissionTpe = "FY";
PHAOP_COM.VAR.CAModelCode = "PHAOPExecuteFY";
PHAOP_COM.VAR.TIMER = "";
PHAOP_COM.VAR.TIMERSTEP = 30 * 1000;
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME)
$(function () {
    COMPOMENTS = OP_COMPOMENTS;
    CheckPermission();      //  验证人员权限
    InitGridOweList();  //  处方列表
    InitGridOweDetail();    //  处方明细
    InitEvent();            //  按钮事件
    ResizePanel();          //  布局调整    
    Clean();                //  包含初始化查询条件
    $("#cardNo").imedisabled();
})
function InitEvent(){
    PHA_EVENT.Bind('#btnFind',          'click', function () {QueryOweList();});
    PHA_EVENT.Bind('#btnReadCard',      'click', function () {ReadCard();});
    
    //表格 toolbar
    PHA_EVENT.Bind('#btnFY',            'click', function () {
        PHAOP_COM.CACert({},ExecuteFY);
    });
    PHA_EVENT.Bind('#btnReturn',        'click', function () {
        PHAOP_COM.CACert({modelName:"PHAOPReturn"},DoReturn);
    });
    PHA_EVENT.Bind('#btnClean',         'click', function () {Clean();});
    $('#prescNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var prescNo = $.trim($("#prescNo").val());
            if (prescNo != "") {
                QueryOweList();
            }
        }
    });
    $('#patNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#patNo").val());
            if (patNo != "") {
                var newPatNo = PHA_COM.FullPatNo(patNo);
                $(this).val(newPatNo);
                if(newPatNo==""){return;}
                QueryOweList();
            }
        }
    });
    //卡号回车事件
    $('#cardNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var cardNo = $.trim($("#cardNo").val());
            if (cardNo != "") {
                ReadCard();
            }
        }
    });
    /* 绑定按钮事件 start*/
    $("#fyFlag").on("change",function(){
        if($(this).is(':checked')==true){
            $('#returnFlag').checkbox('uncheck');       
        }
    })
    $("#returnFlag").on("change",function(){
        if($(this).is(':checked')==true){
            $('#fyFlag').checkbox('uncheck');       
        }
    })
    
}
// 布局调整
function ResizePanel(){
    setTimeout(function () {   
        PHA_COM.ResizePanel({
            layoutId: 'layout-op—grid',
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
function InitGridOweList(){
    var frozenCol=[[
        {field:'pid',               title: ("进程号"),             width:100,      hidden:true},
        {field:'TPatName',          title: ("姓名"),          width:100},
        {field:'TPmiNo',            title: ("登记号"),         width:100},
        {field:'TPrtDate',          title: ("收费日期"),        width:100},
        {field:'TPrtInv',           title: ("收据号"),         width:90,       hidden:true},
        {field:'TPrescNo',          title: ("处方"),          width:120}
        
    ]];
    var normalCol=[[
        {field:'TPrescMoney',       title: ("金额"),          width:70,       align:'right'},
        {field:'TPerSex',           title: ("性别"),          width:40},
        {field:'TPerAge',           title: ("年龄"),          width:40},
        {field:'TPerLoc',           title: ("科室"),          width:100},     
        {field:'TPrescType',        title: ("费别"),          width:70},
        {field:'TCallCode',         title: ("电话"),          width:100},
        {field:'TOweDate',          title: ("欠药时间"),        width:140},
        {field:'TOweUser',          title: ("欠药人"),         width:100},
        {field:'TOweStatusdesc',    title: ("欠药状态"),        width:70},  
        {field:'TOweretdate',       title: ("退药日期"),        width:100},
        {field:'TOweretuser',       title: ("退药人"),         width:70},
        {field:'TMR',               title: ("诊断"),          width:250},
        {field:'TEncryptLevel',     title: ("病人密级"),        width:100,      hidden:PHAOP_COM.ColHidden.PatLevel},       
        {field:'TPatLevel',         title: ("病人级别"),        width:100,      hidden:PHAOP_COM.ColHidden.PatLevel},
        {field:'TPrt',              title:'TPrt',               width:60,       hidden:true},
        {field:'TOwedr',            title:'TOwedr',             width:60,       hidden:true},
        {field:'Tphdrowid',         title:'Tphdrowid',          width:80,       hidden:true}
    ]]
     COMPOMENTS.ComomGrid("gridOweList",{
         columns: normalCol,
         frozenColumns: frozenCol,
         onSelect : function(rowIndex, rowData) {
            QueryOweDetail();
            var prescNo = rowData.TPrescNo;
            PHAOP_COM.InitErpMenu({prescNo:prescNo});   
        },onLoadSuccess : function(data) {
            if(data.total>0){
                $('#gridOweList').datagrid("selectRow",0);
            }else{
                $('#gridOweDetail').datagrid('clear');
            }
        },
        rowStyler:function(index,rowData){
            return COMPOMENTS.GridDifRowStyler(index,rowData,"TPmiNo");
        }
    })
}
function InitGridOweDetail(){
    var normalCol=[[
        {field:'TInciDesc',         title: ("药品名称"),        width:250,align:'left'},
        {field:'TPhUom',            title: ("单位"),          width:60},
        {field:'TPhQty',            title: ("欠药数量"),        width:70,align:'right'},
        {field:'TRealQty',          title: ("预发"),          width:70,
            editor: PHA_GridEditor.NumberBox({
                required: true,
                checkOnBlur: true,
                checkValue: function (val, checkRet) {
                    if (val == "") {
                        checkRet.msg = "不能为空！"
                        return false;
                    }
                    var nQty = parseFloat(val);
                    if (isNaN(nQty)) {
                        checkRet.msg = "请输入数字！";
                        return false;
                    }
                    if (nQty < 0) {
                        checkRet.msg = "请输入大于0的数字！";
                        return false;
                    }
                    var reg = /^[0-9]\d*$/;
                    if (!reg.test(nQty)) {
                        PHAOP_COM._Alert("预发数量只能为整数!")
                        return false;
                    }
                    return true;
                },
                onBlur:function(val, rowData, rowIndex){
                    var realQty = parseFloat(val);;
                    var phQty = rowData.TPhQty;
                    if(phQty<realQty){
                        PHAOP_COM._Alert("预发数量需不大于欠药数量")
                        return false
                    }                               
                }
            })      
        },
        {field:'TDispedqty',            title: ("已发"),      width:70},
        {field:'TPrice',                title: ("单价"),      width:80,       align:'right'},
        {field:'TMoney',                title: ("金额"),      width:80,       align:'right'},
        {field:'TOrdStatus',            title: ("状态"),      width:50},
        {field:'TDoseQty',              title: ("剂量"),      width:50},
        {field:'TPC',                   title: ("频次"),      width:60},
        {field:'TYF',                   title: ("用法"),      width:40},
        {field:'TLC',                   title: ("疗程"),      width:40},
        {field:'TDoctor',               title: ("医师"),      width:70,       hidden:true},
        {field:'TInsuCode',             title: ("医保类别"),    width:70},
        {field:'TIncHW',                title: ("货位"),      width:70},
        {field:'TSpec',                 title: ("规格"),      width:70},
        {field:'TPhbz',                 title: ("备注"),      width:80},
        {field:'TManfDesc',             title: ("生产企业"),    width:200},
        {field:'TKCFlag',               title: ("库存"),      width:50},
        {field:'TKCQty',                title: ("库存数量"),    width:80},
        {field:'TOrditm',               title:'TOrditm',        width:80,       hidden:true},
        {field:'TUnit',                 title:'TUnit',          width:80,       hidden:true},
        {field:'TDoctCode',             title:'TDoctCode',      width:80,       hidden:true},
        {field:'TInci',                 title:'TInci',          width:80,       hidden:true}
        
    ]]; 
    COMPOMENTS.ComomGrid("gridOweDetail",{
        columns: normalCol,
        isCellEdit:true,
        onClickCell: function (index, field, value) {
            if(field != "TRealQty"){return;}
            PHA_GridEditor.Edit({
                gridID: "gridOweDetail",
                index: index,
                field: field
            });
        }
    })
}
function GetParams(){
    var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
    if(retJson[0] == undefined) {return false;}
    var pJson = {};
    pJson = retJson[0];
    if(PHAOP_COM.DEFAULT.phlId == ""){return false;}
    pJson.locId = PHAOP_COM.LogonData.LocId;
    return pJson;
}
// 查询处方列表
function QueryOweList(){
    PHAOP_COM.ClearErpMenu(); // 清除电子病历菜单需要的参数
    var $grid =  $("#gridOweList");
    var pJson = GetParams();
    if(pJson==false){return;}
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.Owe.Api' ,
        pMethodName:'GetOweList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
    Setfocus();
}
// 查询处方明细
function QueryOweDetail(){  
    var $grid =  $("#gridOweDetail");
    var selRowData = $("#gridOweList").datagrid('getSelected');
    if(selRowData == null){return}
    var pJson={};
    pJson.locId = PHAOP_COM.LogonData.LocId;
    pJson.oweId = selRowData.TOwedr;
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.Owe.Api' ,
        pMethodName:'GetOweDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// 清屏
function Clean(){
    if(PHAOP_COM.DEFAULT.RetNeedReq == "Y"){
        $("#btnReturn").css("display","none");
    }
    PHAOP_COM.ClearErpMenu();
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridOweList').datagrid('clear');
    $('#gridOweDetail').datagrid('clear');
    InitDefVal();
    Setfocus();
    
}
// 读卡
function ReadCard(){
    PHA_COM.ReadCard({
        CardNoId : "cardNo",
        PatNoId : "patNo"
    },QueryOweList)

}
function ChkBefDisp(){
    var $grid = $("#gridOweList");
    var rowData = $grid.datagrid('getSelected');
    if(rowData != null){
        var prescno=rowData.TPrescNo;
        var owestat=rowData.TOweStatusdesc;
        var patname=rowData.TPatName;
        var warnInfo=$g("病人姓名:")+patname+"</br>"+$g("处方号:")+prescno+"</br>";
        if((owestat==$g("已发药"))||(owestat==$g("已退药"))){
            PHAOP_COM._Alert(warnInfo+owestat);
            return false;
        }
    }else{
        PHAOP_COM._Msg('error', "请选择配药数据！");
        return false;           
    }
}
// 配药
function ExecuteFY(){
    var $grid = $("#gridOweList");
    var rows = $grid.datagrid('getRows');
    if (rows.length ==0) {
        PHAOP_COM._Msg('error', "明细没有数据！");
        return false;
    }
    var chkFlag = ChkBefDisp();
    if(chkFlag == false){return false;}
    var rowData = $grid.datagrid('getSelected');
    if(rowData != null){
        index = $grid.datagrid('getRowIndex',rowData)
        retVal = OweDispMonitor(index);
        if(retVal == true){PHAOP_COM._Msg("success","欠药发药成功!");}
    }else{
        PHAOP_COM._Msg('error', "请选择欠药发药数据！");
    }
    
    Setfocus();
}
// 欠药程序
function OweDispMonitor(index){
    var detailData = $("#gridOweDetail").datagrid("getRows");
    var chkFlag = 0;        //是否有需要欠药记录
    var allowe = 1;         //
    var zeroFlag = 0;       //是否有需发药记录  
    var rowsDispQtyStr = 0
    for (var rowi = 0; rowi < detailData.length; rowi++) {
        var oeoriQty =  $.trim(detailData[rowi].TPhQty);
        var realQty =  $.trim(detailData[rowi].TRealQty);
        if (parseFloat(realQty) > 0) {
            var zeroFlag = 1;
        }
        if(realQty < 0){
            PHAOP_COM._Alert("预发数量不能小于0!");
            return false
        }
        if (parseFloat(realQty) > parseFloat(oeoriQty)) {
            PHAOP_COM._Alert("预发数量不能大于欠药数量!");
            return false;
        }
        var reg = /^[0-9]\d*$/;
        if (!reg.test(parseFloat(realQty))) {
            PHAOP_COM._Alert("预发数量只能为整数!")
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
        PHAOP_COM._Alert("预发数量不能都为0!");
        return false;
    }
    var rowData =  $("#gridOweList").datagrid("getRows")[index];
    var oweDr=rowData.TOwedr;
    var prescNo=rowData.TPrescNo;
    dispQtyStr = chkFlag + "&&" + allowe + "&&" + rowsDispQtyStr+ "&&" +  oweDr;
    if (chkFlag == "1") {
        PHAOP_COM._Confirm("","<span>"+ prescNo + "</span>"+ $g("是否需要生成欠药单? 点击[确定]生成，点击[取消]退出"), function (r) {
            if (r == true) {
                var retVal = Dispening(index,dispQtyStr)
                return retVal
            } else {
                return false;
            }
        });
    } else {
        var retVal = Dispening(index,dispQtyStr)
        return retVal;
    }

}
// 发药
function Dispening(index,dispQtyStr){
    
    var $grid = $("#gridOweList");
    var rowData = $grid.datagrid("getRows")[index];
    var prescNo = rowData.TPrescNo;
    var pJson ={
        phlId : PHAOP_COM.DEFAULT.phlId,
        winIdStr : PHAOP_COM.DEFAULT.winIdStr,
        fyPerId : PHAOP_COM.DEFAULT.phPerId,
        pyPerId : PHAOP_COM.DEFAULT.phPerId,  // 欠药发药时；配药人=发药人
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
            TOweStatusdesc:$g("已发药"),
            Tphdrowid:phdId
        }   
        $grid.datagrid('updateRowData', {
            index: index,
            row: updData
        });
        var phOweId=tkMakeServerCall("PHA.OP.COM.Print","GetPhOweByPhd",phdId);
        OP_PRINTCOM.PrintPhdOwe(phOweId);
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
// 欠药-退药
function DoReturn(){
    var $grid = $("#gridOweList");
    var rowData = $grid.datagrid('getSelected');
    if(rowData == null){
        PHAOP_COM._Msg('error', "请选择欠药退药数据！");
        return false;
    }
    var rows = $("#gridOweDetail").datagrid('getRows');
    if (rows.length ==0) {
        PHAOP_COM._Msg('error', "明细没有数据！");
        return false;
    }
    var index = $grid.datagrid('getRowIndex',rowData)
    var prescNo=rowData.TPrescNo;
    var oweId=rowData.TOwedr;
    var pJson ={
        prescNo:prescNo,
        oweId:oweId,
        userId:PHAOP_COM.LogonData.UserId
    }
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.Owe.Api',
        pMethodName: 'ExcRetrun',
        pJson: JSON.stringify(pJson)
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        var updData = {
            TOweStatusdesc:$g("已退药"),
            TOweretdate:retVal.data.oweRetDate,
            TOweretuser:retVal.data.oweRetUser
        }   
        $grid.datagrid('updateRowData', {
            index: index,
            row: updData
        });
        PHAOP_COM.SaveCACert({
            signVal:oweId,
            modelName:"PHAOPReturn",
            type:"OH"
        })
        PHAOP_COM._Msg("success", "欠药退药成功,请到收费处退费!"); 
        return true;
    }else{
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
}
// 人员权限
function CheckPermission(){
    PHAOP_COM.CheckPermission({
        permissionType:PHAOP_COM.VAR.PermissionTpe,
        noSelWin:"Y"
    },Clean)
    
}
// 查询or配药后光标位置
function Setfocus()
{
    $("#patNo").val("");
    $("#cardNo").val("");
    if(APP_PROP.FocusFlag == 1){
        $('#cardNo').focus();
    }
    else{
        $('#patNo').focus();
    }
}
