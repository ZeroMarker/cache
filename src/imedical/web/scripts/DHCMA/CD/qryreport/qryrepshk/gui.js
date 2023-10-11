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
  	// LocFlag==0  代表医生站
    if(LocFlag=="0"){
	    $("#cboRepLoc").combobox('setValue',session['LOGON.CTLOCID']);
	    $("#cboRepLoc").combobox('setText',session['LOGON.CTLOCDESC']);
	    $("#cboRepLoc").combobox('disable');
	}
	//报告状态
	obj.chkStatusList = Common_CheckboxToDic("chkStatusList","CRReportStatus",5);
	var DicInfo = $m({                   
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicByDesc",
		argType:"CRReportStatus",
		argDesc:"上报",
		argIsActive:"1"
	},false);
	$('#chkStatusList'+DicInfo.split("^")[0]).checkbox('setValue', (DicInfo.split("^")[0]!="" ? true:false));  
	
	obj.gridRepInfo = $HUI.datagrid("#gridRepInfo",{
		fit: true,
		title:'意外伤害监测报告查询',
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{title:'操作',width:45,field:'expander',align:'center',
				formatter: function(value,row,index){
					var ReportID = row["ReportID"];
					var EpisodeID = row["EpisodeID"];
					if ((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")){
						var btn = '<a href="#" class="icon icon-paper" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					}else{
						var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					}
					return btn;
				}
			}, 
			{field:'link',title:'病历浏览',width:80,align:'center',
			  	formatter: function(value,row,index){
					if(row["OldRepFlag"]==1){
						return;
					}else{
						return " <a href='#'  onclick='objScreen.OpenEMR(\"" + row.EpisodeID + "\",\"" + row.PatientID + "\");'>病历浏览</a>";
					}
			  	}
			},	
			{title: '卡片编号', width: 100, field: 'KPBH'},            
			{title: '登记号', width: 100, field: 'PapmiNo'},       
			{title: '住院号', width: 100, field: 'MrNo'},          
			{title: '姓名', width: 120, field: 'PatName'},      
			{title: '性别', width: 50, field: 'PatSex'},           
			{title: '年龄', width: 50, field: 'PatAge'},         
			{title: '联系电话', width: 120, field: 'TelPhone'},           
			{title: '身份证号', width: 180, field: 'PersonalID'},          
			{title: '职业', width: 180, field: 'Occupation',showTip:true},           
			{title: '现住址', width: 240, field: 'CurrAddress',showTip:true},   
			{title: '伤害发生日期', width: 180, field: 'SHFSRQ'}, 
			{title: '患者就诊日期', width: 180, field: 'HZJZRQ'},              
			{title: '伤害发生原因', width: 120, field: 'SHFSYY'},             
			{title: '伤害发生地点', width: 120, field: 'SHFSDD'},            
			{title: '伤害发生时活动', width: 150, field: 'SHFSSHD'},         
			{title: '是否故意', width: 100, field: 'SHSFGY'},        
			{title: '伤害性质', width: 100, field: 'SHXZ'},
			{title: '伤害诊断', width: 120, field: 'SHZDDesc'},    
			{title: '伤害部位', width: 100, field: 'SHBW'},       
			{title: '诊断ICD', width: 80, field: 'ZDICD'},         
			{title: '报告状态', width: 80, field: 'RepStatusDesc'},
			{title: '报告人', width: 120, field: 'ReportUser'},     
			{title: '报告科室', width: 120, field: 'RepLocDesc'},  
			{title: '报告日期', width: 120, field: 'ReportDate'},  
			{title: '审核人', width: 120, field: 'CheckUser'},      
			{title: '审核日期', width: 120, field: 'CheckDate'}, 
			{title: '伤害结局', width: 120, field: 'SHJJ'},   
			{title: '产品名称1', width: 120, field: 'CPMC1'},   
			{title: '品牌/型号1', width: 120, field: 'CPXH1'},   
			{title: '产品分类1', width: 120, field: 'CPFL1'},  
			{title: '产品名称2', width: 120, field: 'CPMC2'},   
			{title: '品牌/型号2', width: 120, field: 'CPXH2'},   
			{title: '产品分类2', width: 120, field: 'CPFL2'},  
			{title: '典型案例', width: 180, field: 'DXALstr',showTip:true},     
			{title: '退回原因', width: 120, field: 'DelReason'}
		
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


