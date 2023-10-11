//页面Gui
var obj = new Object();
$(function () {
	gridPatList();   //加载患者明细
	InitPatList();
	InitPatDtl(obj);
});

function InitPatList(){	
	var HsopID = $.LOGON.HOSPID;
	var UserID = $.LOGON.USERID;
	var User = $.LOGON.USERDESC;
	Common_ComboToSSHosp("cboHospital",HsopID);
	
	//医院表格联动
	$HUI.combobox('#cboHospital',{
		onSelect:function(data){
			$('#divMain').empty();
			$('#aDateFrom').datebox('setValue',Common_GetCalDate(-7));
			$('#aDateTo').datebox('setValue',Common_GetDate(new Date()));
			gridPatListLoad();
		}
	});
	
	//日期改变事件
	$('#aDateFrom').datebox({
		onChange: function(newValue, oldValue){
			var aDateTo = $('#aDateTo').datebox('getValue');
			if (Common_CompareDate(newValue,aDateTo)>0) {
				$HUI.tooltip("#DateTip",{
					content: '开始日期不能大于结束日期',
					position:'bottom'
				}).show();
				return;
			}
			if (Common_CompareDate(newValue,Common_GetDate(new Date()))>0) {
				$HUI.tooltip("#DateTip",{
					content: '开始日期不能大于当前日期',
					position:'bottom'
				}).show();
				
				return;
			}
			if (DateDiff(newValue,aDateTo)>31) {
				$HUI.tooltip("#DateTip",{
					content: '开始、结束日期间隔超出31天范围',
					position:'bottom'
				}).show();
				
				return;
			}
			$HUI.tooltip("#DateTip").destroy();
			
			$('#divMain').empty();           //清空主区域内容
			$('#divNoResult').attr("style","display:block");		
			gridPatListLoad();        //重新加载患者明细		
		}
	});
	
	//日期改变事件
	$('#aDateTo').datebox({	
		onChange: function(newValue, oldValue){
			var aDateFrom = $('#aDateFrom').datebox('getValue');
			if (Common_CompareDate(aDateFrom,newValue)>0) {	
				$HUI.tooltip("#DateTip",{
					content: '开始日期不能大于结束日期',
					position:'bottom',
					hideDelay: 1000
				}).show();
				return;
			}
			if (DateDiff(aDateFrom,newValue)>31) {
				$('#DateTip').tooltip({
					position: 'right',
					content: '<span style="color:#fff">This is the tooltip message.</span>',
					onShow: function(){
						$(this).tooltip('tip').css({
							backgroundColor: '#666',
							borderColor: '#666'
						});
					}
				});
				$HUI.tooltip("#DateTip",{
					content: '开始、结束日期间隔超出31天范围',
					position:'bottom',
					hideDelay: 1000
				}).show();
				return;
			}
			$HUI.tooltip("#DateTip").destroy();
			
			$('#divMain').empty();           //清空主区域内容
			$('#divNoResult').attr("style","display:block");
			gridPatListLoad();        //重新加载患者明细			
		}
	});
}
 //加载表格
function gridPatList() {
	$HUI.datagrid("#gridPatList",{
		fit: true,
		title: '患者列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		remoteSort:false,   //本地数据排序必须设置为false
		//sortName:'CurrLoc',
		//sortOrder:'desc',
		loadMsg:'数据加载中...',
		columns:[[
			{field:'CurrLoc',title:'科室名称',width:120},
			{field:'RegNo',title:'登记号',width:100},
			{field:'PatName',title:'姓名',width:60}, 
			{field:'CurrBed',title:'床号',width:50,align:'center',
				styler: function(value,row,index){
					if (row.IsNeedAtt==1) {  //需关注
						return 'background-color:#CCFFFF';	
					}
				}	
			},
			{field:'IsMessage',title:'消息',width:40,align:'center',
				formatter: function(value,row,index){
					if (value==1) {
						return "<a style='position: relative;'><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/HAI/img/消息-选中.png'>"
								+((LocFlag==1)&&(row.LocUnRead==1)? "<span style='position: absolute;color:red;bottom:10px;font-size:8px;'>未</span>":'')
								+((LocFlag!=1)&&(row.AdminUnRead==1)? "<span style='position: absolute;color:red;bottom:10px;font-size:8px;'>未</span>":'')
								+"</a>";		
					}else {
						return '';
					}
				}	
			},	
			{field:'NeedRepCnt',title:'需报<br>例次',width:55,align:'center'},
			{field:'VisitStatus',title:'状态',width:50,align:'center'}
		]]
		,rowStyler: function(index,row){
			if (row.IsSusInf==1) { //疑似
				if (row.SuspendCode==0){   //0待处理  1已处理
					return 'color:red'; 
				}
				if (row.SuspendCode==1){   
					return 'color:black'; 
				}
			}else {
				return 'color:gray'; 
			}
		},onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCell
			if (rindex>-1) {
				var rData = $('#gridPatList').datagrid('getRows')[rindex];
				gridPatList_onSelect(rindex,'',rData);
			}	
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
}
	
//加载患者明细
function gridPatListLoad(){
	$("#gridPatList").datagrid("loading");
	$cm ({
		ClassName:'DHCHAI.IRS.CCScreeningSrv',
		QueryName:'QryInfNoRep',
		aDateFrom:$('#aDateFrom').datebox('getValue'), 
		aDateTo:$('#aDateTo').datebox('getValue'), 
		aHospIDs:$('#cboHospital').combobox('getValue'),
		page:1,      //可选项，页码，默认1			
		rows:999    //可选项，获取多少条数据，默认50
	},function(rs){
		$('#gridPatList').datagrid('loadData', rs);				
	});
}
//加载单个病人信息
 function gridPatList_onSelect(pindex,rindex,objAdm){	
	if (!objAdm) return;
	$('#divMain').empty();
	
	loadingWindow();
	if (objAdm) {
		$('#divNoResult').attr("style","display:none");
		window.setTimeout(function () { 
			obj.BuildPatIfo(pindex,'',objAdm,0);  //加载单个病人信息
			disLoadWindow(); 
		}, 100); 
	}
}

//弹出加载层
function loadingWindow() {	
	var left = ($(window).outerWidth(true)) / 2; 
	var top = ($(window).height() - 35) / 2; 
	var height = $(window).height() * 2; 
	$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height,opacity: .7,'z-index': 5000}).appendTo("#divScreen"); 
	$("<div class=\"datagrid-mask-msg\"></div>").html("数据加载中,请稍候...").appendTo("#divScreen").css({ display: "block", left: left, top: top }); 
}

//取消加载层  
function disLoadWindow() {
	$(".datagrid-mask").remove();
	$(".datagrid-mask-msg").remove();
}
