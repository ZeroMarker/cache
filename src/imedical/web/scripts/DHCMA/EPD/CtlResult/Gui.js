
//页面Gui
var objScreen = new Object();
function InitCtlResultWin(){
	var obj = objScreen;
    obj.CasesXID = '';	
    $.parser.parse(); // 解析整个页面  
 
     //初始查询条件
	$HUI.radio("#radDateType2").setValue(true);  
    var nowdate = new Date();
    nowdate.setMonth(nowdate.getMonth()-1);
    var y = nowdate.getFullYear();
    var m = nowdate.getMonth()+1;
    var d = nowdate.getDate();
    var formatwdate = y+'-'+m+'-'+d;
	obj.DateFrom = $('#DateFrom').datebox('setValue', formatwdate);    // 日期初始赋值
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));

	//医院科室联动
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"EPD");
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboLoc = Common_ComboToLoc("cboLoc","E|W","","",HospID);
	    }
    });
   
    //筛查疑似诊断树
    obj.InfDicTreeShow = function() {
	    $m({
			ClassName:"DHCMed.EPDService.SuspInfectDicSrv",
			MethodName:"GetInfectDicTree"
		},function(rs){
			var dataArr=$.parseJSON(rs)
			$('#InfDicTree').tree({
				autoNodeHeight:true,
				lines:true,
				checkbox:true,
				data: dataArr,
				formatter:function(node){
					if (node.children){
						return node.text;
					}else{
						return node.text;
					}
				}
			})
		});
    }

	obj.getChecked = function(){
		var nodes = $('#InfDicTree').tree('getChecked');
		var value = '';
		for(var i=0; i<nodes.length; i++){
            if (nodes[i].id =='DicTree') continue;
			if (value != '') value += ',';
			value += nodes[i].text;
		}
		
		return value;
		
	}
	//筛查结果
    obj.girdCtlResult = $HUI.datagrid("#girdCtlResult",{
		fit: true,
		title:'筛查结果',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, 
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		//sortName:'PapmiNo',
    	sortOrder:'asc',
		/*url:$URL,
	    queryParams:{
			ClassName:'DHCMed.EPDService.SuspCasesXSrv',
			QueryName:'QryCasesX',
			aHospID:$('#cboSSHosp').combobox('getValue'),
			aDateType:Common_RadioValue('radDateType'),
			aDateFrom:$('#DateFrom').datebox('getValue'),
			aDateTo:$('#DateTo').datebox('getValue'),
			aLocID:$('#cboLoc').combobox('getValue'),
			aAdmType:Common_CheckboxValue('chkAdmType'),
			aIsRep:Common_CheckboxValue('chkIsRep'),
            aRstType:Common_CheckboxValue('chkRstType')//加结果类型字段
	    },*/   
		
		columns:[[
			{field:'PapmiNo',title:'登记号',width:100},
			{field:'PatName',title:'姓名',width:100},
			{field:'Sex',title:'性别',width:45,align:'center'},
			{field:'Age',title:'年龄',width:70,align:'center'},
			
			{field:'EpisodeID',title:'病历浏览',width:80,align:'center',
			  	formatter: function(value,row,index){
				  	return " <a href='#' onclick='objScreen.OpenEMR(\"" + row.EpisodeID + "\",\"" + row.PatientID + "\");'>病历浏览</a>";
			  	}
			},	
			{field:'ActDiagnos',title:'疑似诊断',width:150,
				formatter: function(value,row,index){
					if(value=="艾滋病"){
						return "<a href='#' id='ActDiagnos"+row.CasesXID+"' style='white-space:normal;background:red;' onmouseover='objScreen.CasesXDtlTip(\""+row.CasesXID+"\");' >"+value+ "</a>";	
					}
					else{
						return "<a href='#' id='ActDiagnos"+row.CasesXID+"' style='white-space:normal;color:#000' onmouseover='objScreen.CasesXDtlTip(\""+row.CasesXID+"\");' >"+value+ "</a>";
					}
					
				}
			},
			{field:'EpdStatusDesc',title:'处置',width:80,align:'center',
				formatter: function(value,row,index){
					var Opinion = row.Opinion ;
					Opinion = Opinion.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/ /g, "&nbsp;").replace(/\'/g, "&#39;").replace(/\"/g, "&quot;");  
					return " <a href='#' onclick='objScreen.CasesHandleEdit(\"" + row.CasesXID + "\",\"" + row.EpdDiagnosID + "\",\"" + Opinion + "\",\"" + row.ActDiagnosID + "\");'>"+value+ "</a>";
				}
			},
			{field:'AdmType',title:'就诊类型',width:80,align:'center',
				formatter: function(value,row,index){
					if(value=="住院"){
						return "<p style='white-space:normal; color:red'>"+value+"</p>";
					}else{
						return value;
					}
				}
			},
			{field:'EpdDiagnos',title:'确诊诊断',width:150},
			{field:'RepList',title:'同类诊断报告情况',width:450,showTip:true,
			  	formatter: function(value,row,index){
					var OldRepDesc = row.OldRepDesc
				  	if (!value){
					  	if (row.EpdStatusCode=='0') {
							return "<a href='#' class='icon-no' data-options='plain:true,'>"+ (((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")) ? '' : '&nbsp;&nbsp;&nbsp;&nbsp;') +"</a><span style='margin-left:5px'>已排除不允许上报</span>";
						}else {
						  	return "<a href='#' class='icon-add' data-options='plain:true,' onclick='objScreen.btnReport_Click(\"" + row.EpisodeID + "\",\"" + row.PatientID + "\",\"" + row.EpdDiagnosID + "\");'>"+ (((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")) ? '' : '&nbsp;&nbsp;&nbsp;&nbsp;') +"</a><span style='margin-left:5px'>未报</span>";
						}
				  	}else {
				  		var strList = value.split(",");
					  	var len = strList.length;	   
					    var strRet ="";
					  	for (var indx=0;indx<len;indx++){
						  	var ReportID =strList[indx].split(" ")[0];
						  	var Disease =strList[indx].split(" ")[1];
						  	var RepStatus =strList[indx].split(" ")[2];
						  	var RepDate =strList[indx].split(" ")[3];
						  	var RepLoc =strList[indx].split(" ")[4]; 
								strRet +="<a href='#' class='icon-paper-info' style='line-height:30px;' data-options='plain:true,' onclick='objScreen.btnDetail_Click(\"" + ReportID + "\",\"" + row.EpisodeID + "\",\"" + row.PatientID + "\");'>"+ (((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")) ? '' : '&nbsp;&nbsp;&nbsp;&nbsp;') +"</a>"+"<span style='margin-left:5px'>报告ID:"+ReportID+" 诊断:"+Disease+" 状态:"+RepStatus+" 报告日期:"+RepDate+"</span></br>"; 
							}
					  	return strRet;
					}				  	
				}
			},
			{field:'OldRepList',title:'历史已报',width:120,
			  	formatter: function(value,row,index){
					if(value){
						var strRet ="<span style='background:#04B486;'>"+value+"</span>";  	
					}else{
						var strRet=""
					}
					return strRet;
				}
			},
			{field:'IsReVisDesc',title:'复诊',width:60,align:'center',
				formatter: function(value,row,index){
					if(value!=row.IsReAdmDesc){
						return "<div style='white-space:normal;background:yellow;'>"+value+"</p>";
					}else{
						return value;
					}
				}
			},
			{field:'IsCarryDesc',title:'携带',width:60,align:'center'},
			{field:'IsDeclaDesc',title:'网报',width:60,align:'center',
				formatter: function(value,row,index){
					if(value=="网报"){
						if(!row.RepList){
							return "<div style='white-space:normal;background:yellow;'>"+value+"</p>";
						}else{
							return value;
						}
					}else{
						return value;
					}
				}
			},  
			{field:'Remark',title:'备注',width:150,align:'center'},
			{field:'Opinion',title:'处置意见',width:180},			
			{field:'AdmitDate',title:'入院日期',width:100},
			{field:'DisDate',title:'出院日期',width:100},
			{field:'AdmLoc',title:'就诊科室',width:150},
			{field:'AdmWard',title:'就诊病区',width:150},
			{field:'AdmDoc',title:'主管医生',width:100}
		]],
		onRowContextMenu: function (e, rowIndex, rowData) { //右键时触发事件 
			e.preventDefault(); //阻止浏览器捕获右键事件 
			$(this).datagrid("clearSelections"); //取消所有选中项 
			$(this).datagrid("selectRow", rowIndex); //根据索引选中该行 
			$('#menu').menu('show', { 
				//显示右键菜单 
				left: e.pageX,//在鼠标点击处显示菜单 
				top: e.pageY 
			}); 
			e.preventDefault(); //阻止浏览器自带的右键菜单弹出 
		},
		onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
    //传染病诊断
	obj.cboInfect = $HUI.combobox('#cboInfect', {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'RowID',
		textField: 'MIFDisease',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.EPDService.InfectionSrv';
			param.QueryName = 'QryIFList';
			param.ResultSetType = 'array';
		}
	});
	InitCtlResultWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}

