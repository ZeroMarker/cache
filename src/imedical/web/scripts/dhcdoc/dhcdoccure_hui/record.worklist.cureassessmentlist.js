var CureAssessmentDataGrid;

function InitCureAssessmentDataGrid()
{
	var cureToolBar = [{
		id:'BtnUpdate',
		text:'新增/修改', 
		iconCls:'icon-update',  
		handler:function(){
			UpdateAssessment();
		}
	}];
	CureAssessmentDataGrid=$('#tabCureAssessmentList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"DCARowId",
		pageSize : 5,
		pageList : [5,15,50],
		columns :[[ 
        			{field:'DCARowId',title:'',width:1,hidden:true}, 
        			{field:'ApplyNo',title:'申请单号',width:100,align:'left', resizable: true},  
					{field:'PatientName',title:'姓名',width:80,align:'left', resizable: true},   
					{field:'PatOther',title:'患者其他信息',width:200,align:'left', resizable: true},
					{field:'ArcimDesc',title:'治疗项目',width:200,align:'left', resizable: true},
        			{field:'DCAssDate',title:'评估时间',width:110},
        			{field:'DCAssContent',title:'评估内容',width:400,
						styler:function(value,row){
							if(value=="暂未评估"){
								return "color:red;"
							}
						}
        			},  
        			{field:'DCAssUser',title:'创建人',width:90},
        			{field:'DCAssLastUser',title:'最后更新人',width:90},
        			{field:'DCAssLastDate',title:'最后更新时间',width:110},
        			{field:'DCAssRowId',title:'DCAssRowId',width:50,hidden:true}    
    			 ]] ,
    	toolbar : cureToolBar,
    	onDblClickRow:function(rowIndex, rowData){ 
			UpdateAssessment();
       }
	});
}
function CureAssessmentDataGridLoad()
{
	var DCARowIDArr=GetDCARowIDArr();
	if(DCARowIDArr.length==0){return;}
	var DCARowIdStr=DCARowIDArr.join("^");
	if(CureAssessmentDataGrid){
		CureAssessmentDataGrid.datagrid({
			url:$URL,
			queryParams:{
				ClassName:"DHCDoc.DHCDocCure.Assessment",
				QueryName:"FindCureAssessmentList",
				'DCARowIdStr':DCARowIdStr
			}	
		})
		CureAssessmentDataGrid.datagrid("clearSelections")
	}
}

function GetDCARowIDArr(){
	var Ids=[];
	var DCAARowIdStr="";
	if(typeof(PageWorkListAllObj)=="undefined"){
		//治疗预约平台治疗评估
		DCAARowIdStr=ServerObj.DCARowIdStr;
	}else{
		//治疗工作平台治疗评估
		DCAARowIdStr=PageWorkListAllObj._WORK_SELECT_DCAROWID;	
	}
	if(DCAARowIdStr==""){
		return Ids;	
	}
	var DCAARowIdArr=DCAARowIdStr.split("!");
	var StrLen=DCAARowIdArr.length;
	for(var i=0;i<StrLen;i++){
		var DCAARowId=DCAARowIdArr[i];
		var	DCARowId=DCAARowId.split("||")[0];
		if(Ids.indexOf(DCARowId)<0){
			Ids.push(DCARowId);
		}
	}
	return Ids;
}

function UpdateAssessment(){
	var RowStr=GetSelectAssRow();
	if(RowStr==""){return;}
	var DCAccRowId=RowStr.split("^")[0];
	var DCARowId=RowStr.split("^")[1];
	var OperateType=$('#OperateType').val();
	var CureAppFlag=$("#CureAppFlag").val();
	if(typeof(CureAppFlag)=="undefined")CureAppFlag="";
	var href="doccure.cureassessment.hui.csp?OperateType="+OperateType+"&DCARowId="+DCARowId+"&DCAccRowId="+DCAccRowId+"&SourceFlag="+CureAppFlag;
    /*if(CureAppFlag=="CureApp"){
	    var ReturnValue=window.showModalDialog(href,"","dialogWidth:800px;dialogHeight:400px;status:no;center:1;resizable:yes");
		if (ReturnValue !== "" && ReturnValue !== undefined){
			if(ReturnValue){
				CureAssessmentDataGridLoad();	
			}
	    }
	}else{*/
	    websys_showModal({
			url:href,
			title:'治疗评估单',
			width:"800px",height:"400px",
			onClose: function() {
				CureAssessmentDataGridLoad()
			}
		});
	//}
}
function GetSelectAssRow(){
	var rows = CureAssessmentDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("提示","请选择一条治疗记录",'warning');
		return "";
	}else if (rows.length>1){
 		$.messager.alert("错误","您选择了多个治疗记录！",'warning')
 		return "";
	}
	var DCAccRowId=rows[0].DCAssRowId;
	var DCARowId=rows[0].DCARowId;
	if(DCARowId=="")
	{
		$.messager.alert('提示','请选择一条行记录','warning');
		return "";
	}
	return DCAccRowId+"^"+DCARowId;
}