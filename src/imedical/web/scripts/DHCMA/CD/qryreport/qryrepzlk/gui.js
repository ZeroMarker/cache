//页面Gui
var objScreen = new Object();
function InitViewport(){
	var obj = objScreen;		  	
    
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"CD");
	//医院科室联动
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","E","","",HospID);
	    }
    });
    var nowDate = new Date();
    nowDate.setMonth(nowDate.getMonth()-1);
   
	obj.txtFromDate = $('#txtFromDate').datebox('setValue', Common_GetDate(nowDate));// 日期初始赋值
	obj.txtToDate = $('#txtToDate').datebox('setValue', Common_GetDate(new Date()));
	//报告状态
	obj.chkStatusList =function() {
		var ItemCode = "chkStatusList";
		var DicType = "CRReportStatus";
		
		var strDicList =$m({
			ClassName:"DHCMed.SSService.DictionarySrv",
			MethodName:"GetDicsByType",
			aType:DicType,
			aActive:1
		},false);
		
		var dicList = strDicList.split(String.fromCharCode(1));
		var len =dicList.length;	
		
		listHtml ="<div>"; 
		for (var index =0; index< len; index++) {
			var dicSubList = dicList[index].split(String.fromCharCode(2));	
			listHtml += " <input id="+ItemCode+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[1]=='上报'? "checked='true'":"")+" label="+dicSubList[1]+"  name="+ItemCode+"  value="+dicSubList[0]+">";  
		}
		listHtml +="</div>"
		$('#'+ItemCode).html(listHtml); 
		$.parser.parse('#'+ItemCode);  //解析checkbox	
		
	}
	
	obj.gridRepInfo = $HUI.datagrid("#gridRepInfo",{
		fit: true,
		title:'肿瘤报告查询',
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{title:'操作',width:45,field:'expander',align:'center',
				formatter: function(value,row,index){
					var ReportID = row["ReportID"];
					var EpisodeID = row["EpisodeID"];
					var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					return btn;
				}
			}, 
			{title: '卡片编号', width: 100, field: 'KPBH'},        
			{title: '登记号', width: 100, field: 'PapmiNo'},       
			{title: '住院号', width: 100, field: 'MrNo'},          
			{title: '姓名', width: 120, field: 'PatName'},      
			{title: '性别', width: 50, field: 'PatSex'},           
			{title: '年龄', width: 50, field: 'PatAge'},           
			{title: '诊断', width: 120, field: 'ZDDesc'},          
			{title: '诊断ICD', width: 80, field: 'ZDICD'},         
			{title: '报告状态', width: 80, field: 'RepStatusDesc'},
			{title: '报告人', width: 120, field: 'ReportUser'},     
			{title: '报告科室', width: 120, field: 'RepLocDesc'},  
			{title: '报告日期', width: 120, field: 'ReportDate'},  
			{title: '审核人', width: 120, field: 'CheckUser'},      
			{title: '审核日期', width: 120, field: 'CheckDate'},   
			{title: '死亡日期', width: 120, field: 'SWRQ'},        
			{title: '死亡原因', width: 120, field: 'SWYY'}        
			
		]],
		onDblClickRow:function(index, row) {
			if (index>-1) {
				obj.gridRepInfo_click();
			}
		},onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});

	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


