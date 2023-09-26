//页面Gui
function InitSpeQueryWin(){
	var obj = new Object();		
    
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"SPE");
	 //医院科室联动
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboLoc = Common_ComboToLoc("cboLoc","E","","",HospID);
	    }
    });

	obj.DateFrom = $('#DateFrom').datebox('setValue', Common_GetDate(new Date()));    // 日期初始赋值
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));
	
	obj.cboPatTypeSub = $HUI.combobox('#cboPatTypeSub', {
		url: $URL,
		editable: true,
		mode: 'remote',
		valueField: 'PTSID',
		textField: 'PTSDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.SPEService.PatTypeSub';
			param.QueryName = 'QryAllPatTypeSub';
			param.ResultSetType = 'array';
		},
	});
	
   //状态checkbox
   obj.chkStatus = function() {
	   $m({
			ClassName:"DHCMed.SPEService.PatientsSrv",
			MethodName:"GetDicForCheckGroup",
			aType:"SPEStatus",
			aActive:1
		},function(txtData){
			var dicList = txtData.split(",");
			//var listHtml=''; 
			for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
				var dicSubList = dicList[dicIndex].split("^");
				$("#chkStatusList").append(
					 "<input id="+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='checked'":"")+" label="+dicSubList[1]+" name='chkStatus' value="+dicSubList[0]+">"
				);
				//listHtml += " <input id="+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='true'":"")+" label="+dicSubList[1]+"  name='chkStatus' value="+dicSubList[0]+">";  
			}
			//$("#chkStatusList").html(listHtml); 
			$.parser.parse("#chkStatusList");  //解析checkbox
		});
   }
   
	obj.GetStatus = function() {
	    var Status = "";
		$("input[name='chkStatus']:checked").each(function(){
		      Status = Status + $(this).val()+ ","; 
		});
		if (Status!="") { Status = Status.substring(0, Status.length-1); }
		return Status;
	}
 
   obj.gridSpeQuery = $HUI.datagrid("#SpeQuery",{
		fit: true,
		title:'特殊患者查询',
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
			{field:'RegNo',title:'登记号',width:'100'},
			{field:'PatName',title:'患者姓名',width:'80'},
			{field:'Sex',title:'性别',width:'50'},
			{field:'PatientAge',title:'年龄',width:'50'},
			{field:'AdmDate',title:'入院日期',width:'100'},
			{field:'PatTypeDesc',title:'患者类型',width:'120'}, 
			{field:'StatusDesc',title:'状态',width:'50',
				 styler: function(value,row,index){
					var retStr = "", tmpStatusCode = row["StatusCode"];
					if (tmpStatusCode==1) {
						retStr =  'color:red;';
					} else if (tmpStatusCode==2) {
						retStr = 'color:green;';
					}else if (tmpStatusCode==3) {
						retStr = 'color:blue;';
					} else if (tmpStatusCode==0) {
						retStr = 'color:black;';
					} 
					return retStr;
				}
			}, 
			{field:'ReadStatus',title:'消息',width:'80'}, 
			{field:'Note',title:'情况说明',width:'150'},
			{field:'MarkDate',title:'标记日期',width:'100'},
			{field:'CheckOpinion',title:'审核意见',width:'150'},
			{field:'CheckDate',title:'审核日期',width:'100'},
			{field:'DutyDeptDesc',title:'责任科室',width:'120'},	
			{field:'LocDesc',title:'就诊科室',width:'120'},
			{field:'WardDesc',title:'病区',width:'120'},
			{field:'Bed',title:'床号',width:'60'},
			{field:'DoctorName',title:'主管医生',width:'80'},
			{field:'EpisodeID',title:'就诊号',width:'50'}		
		]],onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});

	InitSpeQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


