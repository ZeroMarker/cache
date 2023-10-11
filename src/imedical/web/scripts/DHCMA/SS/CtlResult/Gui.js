//页面Gui
var objScreen = new Object();
function InitCtlResultWin(){
	var obj = objScreen;
    obj.CasesXID = '';	
    $.parser.parse(); // 解析整个页面  
 
    //初始查询条件
	$HUI.radio("#radDateType1").setValue(true);  
	obj.DateFrom = $('#DateFrom').datebox('setValue', Common_GetDate(new Date()));    // 日期初始赋值
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));
	//医院科室联动
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,ProductCode);
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboLoc = Common_ComboToLoc("cboLoc","E|W","","",HospID);
	    }
    });
   
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
		//checkOnSelect   : true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		//sortName:'PapmiNo',
    	sortOrder:'asc',
		url:$URL,
	    queryParams:{
			 ClassName:'DHCMed.SSService.CaseXSrv',
			QueryName:'QryPatInfo',
			aProductCode:ProductCode,
			aHospIDs:$('#cboSSHosp').combobox('getValue'),
			//aDateType:Common_RadioValue('radDateType'),
			aDateFrom:$('#DateFrom').datebox('getValue'),
			aDateTo:$('#DateTo').datebox('getValue'),
			aLoc:$('#cboLoc').combobox('getValue'),
			aAdmType:Common_CheckboxValue('chkAdmType'),
			aStatus:Common_CheckboxValue('chkStatus')
			
	    },
		columns:[[
			//{field:'cbxFlag', checkbox:'true', width:30},
			{field:'PapmiNo',title:'登记号',width:100},
			{field:'PatName',title:'姓名',width:70},
			{field:'Sex',title:'性别',width:45,align:'center'},
			{field:'Age',title:'年龄',width:70,align:'center'},
			{field:'StatusDesc',title:'处置状态',width:80,align:'center',
				formatter: function(value,row,index){
					if(value=="标记上报"){
						return "<p style='white-space:normal; color:red'>"+value+"</p>";
					}else if(value=="排除"){
						return "<p style='white-space:normal; color:green'>"+value+"</p>";
					}else{
						return value
					}
				}
			},
			{field:'PatientID',title:'病历浏览',width:80,align:'center',
			  	formatter: function(value,row,index){
				  	return " <a href='#' style='white-space:normal; color:#017bce' onclick='objScreen.OpenEMR(\"" + row.EpisodeID + "\",\"" + row.PatientID + "\");'>病历浏览</a>";
			  	}
			},	
			{field:'ActDiagnosDesc',title:'触发诊断',width:150,
				formatter: function(value,row,index){
					return "<a href='#' id='ActDiagnosDesc"+row.CasesXID+"' style='white-space:normal;color:#000' onmouseover='objScreen.CasesXDtlTip(\""+row.CasesXID+"\");' >"+value+ "</a>";
				}
			},
			{field:'RepTypeDesc',title:'对应报卡类型',width:150,
				formatter: function(value,row,index){
					if (ProductCode=="CD"){
						return "<a href='#' data-options='plain:true' onclick='objScreen.btnReport_Click(\""+ProductCode+"\",\"" + row.EpisodeID + "\",\"" + row.PatientID + "\",\"" + row.ActDiagnosID + "\",\""+row.RepTypeCode+"\");'>"+value+"报告卡</a>";
					}else if(ProductCode=="FBD"){
						return "<a href='#' data-options='plain:true' onclick='objScreen.btnReport_Click(\""+ProductCode+"\",\"" + row.EpisodeID + "\",\"" + row.PatientID + "\",\"" + row.ActDiagnosID + "\",\""+row.RepTypeCode+"\");'>食源性疾病报告卡</a>";
					}else{
						return value+"报卡"
					}
					
				}
			},
			{field:'RepList',title:'历史报卡记录',width:400,align:'left',
			  	formatter: function(value,row,index){
				  	if (!value){
					  	if (row.StatusDesc=='排除') {
							var Opinion=row.Opinion
							if  (Opinion!=""){
								Opinion="("+Opinion+")";
							}
					  		return "<a href='#' class='icon-no'  data-options='plain:true,'></a><span style='padding-left:5px;'>已排除不须上报</span>"+Opinion;
					  	}else {
						  	return "<a href='#' class='icon-add' data-options='plain:true,' onclick='objScreen.btnReport_Click(\""+ProductCode+"\",\"" + row.EpisodeID + "\",\"" + row.PatientID + "\",\"" + row.ActDiagnosID + "\",\""+row.RepTypeCode+"\");'></a><span style='padding-left:5px;'>未报</span>";
					  	}
				  	}else {
				  		var strList = value.split("^");
					  	var len = strList.length;	   
					    var strRet ="";
					  	for (var indx=0;indx<len;indx++){
						  	var ReportID =strList[indx].split("||")[0];
						  	var typeDesc =strList[indx].split("||")[1];
						  	var RepStatus =strList[indx].split("||")[5];
						  	var RepDate =strList[indx].split("||")[2];
						  	var RepLoc =strList[indx].split("||")[4];
					        strRet +="<a href='#' class='icon-paper-info' style='line-height:30px;white-space:normal;color:green' data-options='plain:true,' onclick='objScreen.btnDetail_Click(\""+ProductCode+"\",\"" + ReportID + "\",\"" + row.EpisodeID + "\",\"" + row.PatientID + "\",\"" + row.ActDiagnosID + "\",\""+row.RepTypeCode+ "\");'></a><span style='padding-left:5px;'></span>"+
							//"<span>报告ID:"+ReportID+
							typeDesc+
							" 状态:"+RepStatus+" 报告日期:"+RepDate+"</span>"
							+"</br>"					
					  	}
					  	return strRet;
					}				  	
				}
			},
			{field:'AdmDoc',title:'主管医生',width:100},
			{field:'AdmTypeDesc',title:'就诊类型',width:80,align:'center',
				formatter: function(value,row,index){
					if(value=="住院"){
						return "<p style='white-space:normal; color:red'>"+value+"</p>";
					}else{
						return value;
					}
				}
			},
			/*{field:'Opinion',title:'处置意见',width:180},		*/	
			{field:'AdmitDate',title:'入院日期',width:100},
			{field:'DisDate',title:'出院日期',width:100},
			{field:'AdmLoc',title:'就诊科室',width:150},
			{field:'AdmWard',title:'就诊病区',width:150},
			
			{field:'EpisodeID',title:'就诊号',width:150},
		]]
		,onDblClickRow : function(index, row){
			//双击新建报表
			obj.btnReport_Click(ProductCode,row.EpisodeID,row.PatientID,row.ActDiagnosID,row.RepTypeCode)
		}
		,onLoadSuccess : function(data){
			if (data.length<1){
				console.log(data.length)
				$('#girdCtlResult').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
			}
		}
		,onLoadError : function(XMLHttpRequest, textStatus, errorThrown) {
				// 通常情况下textStatus和errorThown只有其中一个有值 
				//console.dir(XMLHttpRequest); 
				console.dir(textStatus);
				//console.dir(errorThrown);
		}
	});
	
	InitCtlResultWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


