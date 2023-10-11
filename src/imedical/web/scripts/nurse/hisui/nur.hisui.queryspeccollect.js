var GV = {
    _CLASSNAME: "Nur.NIS.Service.SpecManage.CollectRecord"
};
$(function(){
	if (HISUIStyleCode=="lite") $(".panel-body").css("background-color","#f5f5f5");
	initUI();
})

function initUI() {
	getWardData();
	// 默认开始日期和结束日期为当前日期
	var curDate=new Date();
	var year=curDate.getFullYear();
	var month=curDate.getMonth()+1;
	month=month<10 ? "0"+month : month;
	var day=curDate.getDate();		
	$('#startDate,#endDate').datebox("setValue",year+"-"+month+"-"+day);
	$('#regNo,#medNo,#cardNo').bind('keydown', function (e) {
        if (e.keyCode == 13) {
	        var value=$.trim($(this).val());
	        var reduceNums=10-value.length;
	        if(0<reduceNums<10){
		    	for(var i=0;i<reduceNums;i++){
			    	value="0"+value;	
			    }
			    $(this).val(value);  
		    }
            reloadDataGrid();
        }
    });    
    initTable();
    reloadDataGrid();
}
/*----------------------------------------------------------------------------------------------------------*/
/**
 * @description  获取病区
 * @param {*} jsonData
 */
function getWardData() {
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		QueryName:"GetallWardNew",
		desc:"",
		hospid:session['LOGON.HOSPID'],
		bizTable: "ARC_ItmMast"
	},function(data){
		$HUI.combobox("#ward", {
		    valueField: "wardid",
		    textField: "warddesc",
		    disabled: true,
		    data:data.rows,
			onLoadSuccess:function(){
				$(this).combobox('setValue', session['LOGON.WARDID']);
			}
		});	
	})
    
}

// 初始化table
function initTable(){ 
	$("#dg").datagrid({
		toolbar:"#toolbar",
		frozenColumns:[[
			{field:"patName",title:"患者姓名",width:100},
			{field:"regNo",title:"登记号",width:100},
			{field:"bedCode",title:"床号",width:50},
			{field:"patSex",title:"性别",width:50},
			{field:"patAge",title:"年龄",width:50},
			{field:"specName",title:"标本名称",width:120},
			{field:"labNO",title:"标本号",width:100},
			{field:"arcim",title:"医嘱名称",width:300}			
		]],
		columns:[[
			{field:"containerColor",title:"容器颜色",width:70,styler: function(value,row,index){
				return "background-color:"+value;	
			},formatter: function(value,row,index){
				return "";	
			}},
			{field:"containerName",title:"容器名称",width:120},
			{field:"ordNote",title:"申请备注",width:120},
			{field:"collDateTime",title:"采血时间",width:150},
			{field:"collUser",title:"采血护士",width:100},
			{field:"sttDateTime",title:"要求执行时间",width:150},
			{field:"execDateTime",title:"执行时间",width:150},
			{field:"execNurse",title:"执行人",width:100}
					
		]],
		loadMsg : '加载中..'	
	})	
}
function reloadDataGrid(){
	var startDate=$('#startDate').datebox("getValue");	
    var endDate=$('#endDate').datebox("getValue");	
	var regNo=$.trim($("#regNo").val());
	var labNo=$.trim($("#labNo").val());
	var medNo=$.trim($("#medNo").val());
	var cardNo=$.trim($("#cardNo").val());
	var collectFlag="W",carrySheetFlag="";
	/*var collected=$("#cb").radio('getValue');
	var unCollect=$("#cb2").radio('getValue');
	if(collected && !unCollect) collectFlag="A";
	if(!collected && unCollect) collectFlag="U";
	if(!collected && !unCollect) collectFlag="";*/
	var collected=false,unCollect=false;
	var statusArr=$("#StateBox").combobox("getValues");
	for (var i=0;i<statusArr.length;i++){
		if (statusArr[i]=="A") collected=true;
		else if (statusArr[i]=="U") unCollect=true;
		else {
			if (carrySheetFlag=="") carrySheetFlag=statusArr[i];
			else  carrySheetFlag=carrySheetFlag+"^"+statusArr[i];
		}
	}
	if(collected && !unCollect) collectFlag="A";
	if(!collected && unCollect) collectFlag="U";
	if(!collected && !unCollect) collectFlag="";
	if(startDate=="" || endDate==""){
		return $.messager.popover({ msg: '日期不能为空！', type:'alert' });
	}	
    $cm({
        ClassName: GV._CLASSNAME,
        MethodName: "GetSpecCollectRecord",
        wardID:session['LOGON.WARDID'],
        startDate: startDate,
        endDate: endDate,
		regNo: regNo,
		medNo:medNo,
		cardNo:cardNo,
		collectFlag:collectFlag,
		curLabNo:labNo,
		carrySheetFlag:carrySheetFlag
    },function(data) {
        $("#dg").datagrid("loadData",data);	
    });		
}