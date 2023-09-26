//页面Gui
var objScreen = new Object();
function InitAssResultWin(){
	var obj = objScreen;
    obj.RecRowID = '';	
   
    obj.gridAssResult = $HUI.datagrid("#AssessResult",{
		fit: true,
		title:'疑似病例筛查评估结果',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:false,		
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
		/*url:$URL,
	    queryParams:{
			ClassName:'DHCHAI.AMS.AssessResultSrv',
			QueryName:'QryAssessResult'
	    },
	    */
		columns:[[
			{field:'PapmiNo',title:'登记号',width:110,sortable:true},
			//{field:'MrNo',title:'病案号',width:120,sortable:true},
			{field:'PatName',title:'姓名',width:80},
			{field:'Sex',title:'性别',width:50,sortable:true},
			{field:'Age',title:'年龄',width:50},
			{field:'AdmDate',title:'入院日期',width:100,sortable:true},
			{field:'DischDate',title:'出院日期',width:100,sortable:true},
			{field:'InfRepList',title:'感染报告情况',sortable:true,width:200,
				formatter: function(value,row,index){
					if (!value){
					  	return "";
				  	}else {
				  		var strList = value.split("^");
					  	var len = strList.length;	   
					    var strRet ="";
					  	for (var indx=0;indx<len;indx++){
						  	var ReportID =strList[indx].split(" ")[0];
						  	var InfDate =strList[indx].split(" ")[1];
						  	var InfPos =strList[indx].split(" ")[2];
						  	var InfSub =strList[indx].split(" ")[3];
							if (InfSub) {
								InfPos = InfPos+"("+InfSub+")"
							}
						  	var RepStatus =strList[indx].split(" ")[4];
					        strRet +="<a href='#' class='icon-paper-info' style='line-height:30px;' data-options='plain:true,' onclick='objScreen.btnDetail_Click(\"" + ReportID + "\",\"" + row.EpisodeID + "\");'>&nbsp;&nbsp;&nbsp;&nbsp;</a><span>"+" "+InfPos+"&nbsp;&nbsp;"+RepStatus+"</span></br>";
					  	}
					  	return strRet;
					}	
				}
			},
			//{field:'IsActDesc',title:'是否有效',width:70,align:'center',sortable:true},
			{field:'EpisodeID',title:'摘要',width:60,sortable:true,align:'center',
				formatter: function(value,row,index){
					return " <a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenView(\"" + row.EpisodeID + "\");'>摘要</a>";
				}
			},
			{field:'StatusDesc',title:'状态',width:70,sortable:true,align:'center',
				formatter: function(value,row,index){
					return " <a href='#' style='white-space:normal; color:blue' onclick='objScreen.ResultEdit(\"" + row.ID + "\",\"" + row.Status + "\",\"" + row.DiagDate + "\",\"" + row.DiagNote + "\");'>"+value+ "</a>";
				}
			},
			/*{field:'DiagNote',title:'依据',width:100},
			{field:'DiagDate',title:'确诊日期',width:100},
			{field:'OprStatus',title:'处置情况',width:80,sortable:true,align:'center',
				formatter: function(value,row,index){
					if (value=="未处理"){
					  	return value;
				  	}else {
						return "<a href='#' id='ScreenLog"+row.EpisodeID+"' style='white-space:normal;color:#000' onmouseover='objScreen.SreenLogTip(\""+row.EpisodeID+"\");' >"+value+ "</a>";
				  	}
				}
			},
			{field:'InfTypeDesc',title:'评估类型',width:80,sortable:true},
			*/
			{field:'LabList',title:'检出菌',width:150,
				formatter: function(value,row,index){
					if (value){
					  	var strList = value.split(",");
					  	var len = strList.length;
					    var strRet ="";
					  	for (var indx=0;indx<len;indx++){
				            var Diagons =strList[indx];
					         strRet +=Diagons+"</br>";  	
					  	}
					  	return strRet;
				  	}else {
						return "";
				  	}
				}
			},
			
			{field:'SusResult',title:'疑似筛查结果',width:150},
			{field:'AdmDiagonsList',title:'入院诊断',width:120},
			{field:'DiagonsList',title:'出院诊断',width:200,
				formatter: function(value,row,index){
					if (value){
					  	var strList = value.split(",");
					  	var len = strList.length;
					    var strRet ="";
					  	for (var indx=0;indx<len;indx++){
				            var Diagons =strList[indx];
					         strRet +=Diagons+"</br>";  	
					  	}
					  	return strRet;
				  	}else {
						return "";
				  	}
				}
			},
		
			{field:'SusDiagnos',title:'疑似诊断',width:150},
			{field:'AdmLoc',title:'科室',width:150,sortable:true},
			{field:'AdmWard',title:'病区',width:150,sortable:true}
			//{field:'RstDate',title:'处置日期',width:100},
			//{field:'RstTime',title:'处置时间',width:100}, 
			//{field:'RstUserDesc',title:'处置人',width:100}
		]],
		onLoadSuccess:function(data){
			$(".datagrid-mask").remove();
	    	$(".datagrid-mask-msg").remove();
		}
	});
	
	//评估模型
	obj.cbgModel = $HUI.combogrid('#cbgModel', {
		panelWidth: 400,
		editable: true,
	    pagination: true,
		blurValidValue: true, //为true时，光标离开时，检查是否选中值,没选中则置空输入框的值
		fitColumns: true,     //真正的自动展开/收缩列的大小，以适应网格的宽度，防止水平滚动条
		mode:'remote',        //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		idField: 'ID',
		textField: 'AMDesc',
		multiple: false,
		url: $URL,
		queryParams:{ClassName: 'DHCHAI.AMS.AssessModelSrv',QueryName: 'QryAssessModel',aIsActive:1},
		columns: [[
			{field:'AMCode',title:'评估代码',width:80},
			{field:'AMDesc',title:'评估模型',width:240}
		]]
	});
	
	
	//状态
	$('#cboStatus').combobox({      
		valueField:'Code',    
		textField:'Desc',  //0排除、1确诊、2自报
		data : [ {
			Code:'0', 
			Desc:'排除'
		},{
			Code:'1', 
			Desc:'确诊'
		},{
			Code:'2', 
			Desc:'自报'
		}],
		onSelect:function(rows) {
			if (rows.Code!=0){
				$('#dtDiagDate').datebox('enable');			
			}else {
				$('#dtDiagDate').datebox('disable');
				$('#dtDiagDate').datebox('clear');
			}
		}
	});  
	obj.cboInfPos = $HUI.combobox("#cboInfPos", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'Desc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.InfPosSrv&QueryName=QryInfPosToSelect&ResultSetType=array&aPosFlg=2";
		   	$("#cboInfPos").combobox('reload',url);
		},
		onChange:function(newValue,oldValue){				
			 obj.gridAssResultLoad();
		}
	});
	
	InitAssResultWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


