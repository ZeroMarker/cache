var PageLogicObj={
	m_patientListTabDataGrid:"",
	AllNurse:0
};
$(function(){
	if (ServerObj.MasterType=="") {
		$(".window-mask.alldom").show();
		return false;
	}else{
		$(".window-mask.alldom").hide();
	}
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
});
function InitEvent(){
	$('#patientNo').bind('keypress', function(event) {
			if (event.keyCode == "13") {
				setpatientNoLength();
			}
		});
	if ($("#patientName").length>0){
		$('#patientName').bind('keypress', function(event) {
			if (event.keyCode == "13") {
				patientListTabDataGridLoad();
			}
		});
	}
	$("#Search").click(patientListTabDataGridLoad);
	$HUI.radio("input[name='DocSearch']",{
        onChecked:function(e,value){
	    	patientListTabDataGridLoad();
        }
	})
	$HUI.radio("input[name='NurseSearch']",{
        onChecked:function(e,value){
	    	patientListTabDataGridLoad();
        }
	})
	$HUI.radio("input[name='CashSearch']",{
        onChecked:function(e,value){
	    	patientListTabDataGridLoad();
        }
	})
	$HUI.radio("#DocAgreeYes,#DocAgreeNo",{
        onChecked:function(e,value){
	    	var DocAgree=$("input[name='DocAgree']:checked").val();
	    	if (DocAgree=="Y"){$("#DocReason").hide();$("#DocReasonlabe").hide();}else{$("#DocReason").show();$("#DocReasonlabe").show();}
        }
	})
	
	$HUI.radio("#NurseAgreeYes,#NurseAgreeNo",{
        onChecked:function(e,value){
            NurseAgreeCheckChange();
        }
	})
	$("#DocArgeeSave").click(SaveDocAgree);
	$("#NurseArgeeSave").click(SaveNurseAgree);
	$cm({
		ClassName:"web.DHCDocIPBookPreAditu",
		MethodName:"GetLoacBed",
		LocID:session['LOGON.CTLOCID'],
	},function(rtn){
		 var cbox = $HUI.combobox("#NurseBed", {
			valueField: 'id',
			textField: 'desc',
			editable:false, 
			data: rtn,
			onSelect: function (rec) {
			}
	   });
	})
	$('#NurseBedDate').datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date >= (now.setDate(now.getDate()-1));
			}
		});
}
function PageHandle(){
	if (ServerObj.MasterType=="Doc"){$HUI.radio("#DocSearch1").setValue(true);
	}else if(ServerObj.MasterType=="Nurse"){
		$HUI.radio("#NurseSearch1").setValue(true);	
	}else if(ServerObj.MasterType=="Cash"){
		$HUI.radio("#CashSearch1").setValue(true);
	}
	patientListTabDataGridLoad();
}
function Init(){
	PageLogicObj.m_patientListTabDataGrid=InitpatientListTabDataGrid();
}
function InitpatientListTabDataGrid(){
	if (ServerObj.MasterType=="Doc"){
		var Columns=[[ 
			{field:'Check',title:'选择',checkbox:'true',align:'center',width:70,auto:false},
			{field:'PatientID',title:'PatientID',width:80,hidden: true},
			{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
			{field:'mradm',title:'mradm',width:80,hidden: true},
			{field:'PAPMINO',title:'登记号',width:100},  
			{field:'PAPMIName',title:'姓名',width:80},
			{field:'PAPMISex',title:'性别',width:50},
			{field:'PAPMIAge',title:'年龄',width:50},
			{field:'PAPMIDOB',title:'出生日期',width:100},
			{field:'Diagnosis',title:'诊断',width:150},
			{field:'LabReport',title:'检验结果',width:150,
				formatter:function(value,rec){  
					var btn="<div style=''><div id='Lab' onclick='ShowLabReport("+ rec.EpisodeID+","+rec.PatientID+","+rec.mradm+")'>"
		    		var btn=btn+"<span id='LabCount' style='display:none;'>0</span>"
		    		if (HISUIStyleCode=="lite"){
		    		var btn=btn+"<span class='icon-funnel-empty' id='Lab_1'></span><span id='Lab_11'>"+ rec.Lab1+"</span>"
		    		var btn=btn+"<span class='icon-funnel-eye' id='Lab_2'></span><span id='Lab_21' >"+ rec.Lab2+"</span>"
		    		var btn=btn+"<span class='icon-funnel-half' id='Lab_3'></span><span id='Lab_31'>"+ rec.Lab3+"</span>"
		    		}else{
			    	var btn=btn+"<span class='icon-funnel-empty' style='padding-left: 20px;' id='Lab_1'></span><span id='Lab_11'>"+ rec.Lab1+"</span>"
		    		var btn=btn+"<span class='icon-funnel-eye' style='padding-left: 20px;' id='Lab_2'></span><span id='Lab_21' >"+ rec.Lab2+"</span>"
		    		var btn=btn+"<span class='icon-funnel-half' style='padding-left: 20px;' id='Lab_3'></span><span id='Lab_31'>"+ rec.Lab3+"</span>"	
			    		}
	    			var btn=btn+ "</div></div>"
					return btn;
                }
              },
			{field:'ExamReport',title:'检查结果',width:150,formatter:function(value,rec){  
					var btn="<div style=''><div id='Exam' onclick='ShowExamReport("+ rec.EpisodeID+","+rec.PatientID+","+rec.mradm+")'>"
		    		var btn=btn+"<span id='ExamCount' style='display:none;'>0</span>"
		    		if (HISUIStyleCode=="lite"){
			    	var btn=btn+"<span  class='icon icon-funnel-empty'   id='Exam_1'></span><span id='Exam_11'>"+ rec.Exam1+"</span>"
		    		var btn=btn+"<span  class='icon icon-funnel-eye'  id='Exam_2'></span><span id='Exam_21'>"+ rec.Exam2+"</span>"
		    		var btn=btn+"<span  class='icon icon-funnel-half'  id='Exam_3'></span><span id='Exam_31'>"+ rec.Exam3+"</span>"
	
			    		}else{
		    		var btn=btn+"<span  class='icon icon-funnel-empty' style='padding-left: 20px;'  id='Exam_1'></span><span id='Exam_11'>"+ rec.Exam1+"</span>"
		    		var btn=btn+"<span  class='icon icon-funnel-eye' style='padding-left: 20px;' id='Exam_2'></span><span id='Exam_21'>"+ rec.Exam2+"</span>"
		    		var btn=btn+"<span  class='icon icon-funnel-half' style='padding-left: 20px;' id='Exam_3'></span><span id='Exam_31'>"+ rec.Exam3+"</span>"
					}
	    			var btn=btn+ "</div></div>"
					return btn;
                }
              },
			{field:'InsertOrder',title:'录入医嘱',width:80,formatter:function(value,rec){  
					var btn="<span  onclick='ShowOrder("+ rec.EpisodeID+","+rec.PatientID+","+rec.mradm+")' class='icon icon-write-order' style='display:block;width:100%;'>&nbsp;&nbsp</span>"
					return btn;
                }},
			{field:'DocAduit',title:'审核医生',width:80},
			{field:'DocActive',title:'医生审核结果',width:100},
			{field:'DocRemark',title:'医生备注',width:120},
			{field:'DocReason',title:'医生不通过原因',width:120},
			{field:'NurseActive',title:'护士审核结果',width:100,hidden: true},
			{field:'NurseRemark',title:'护士备注',width:120,hidden: true},
			{field:'NurseReason',title:'护士不通过原因',width:120,hidden: true},
   		 ]]
   		var ToolBar = [{
            text: '审核',
            iconCls: 'icon-ok',
            handler: function() { 
	            var row=PageLogicObj.m_patientListTabDataGrid.datagrid('getSelections');
				if ((!row)||(row.length==0)){
					$.messager.alert("提示","请选择需要审核病人!");
					return false;
				}
				if ((row.length!=1)){
					//$.messager.alert("提示","正在批量审批,请确认!");
					ClearDocAgree()
				}else{
					if (row[0].NurseActive=="通过"){
						$.messager.alert("提示","护士审核已通过,不能修改审核结果!");
						return false;
					}
					var OneEpisodeID=row[0].EpisodeID
					InitOneDocAgree(OneEpisodeID)
				}
	            $('#DocAgree-dialog').window('open'); 
            }
        }
		]
		var singleSelectFlag=false
   		
	}else if(ServerObj.MasterType=="Nurse"){
		var Columns=[[ 
			{field:'Check',title:'选择',checkbox:'true',align:'center',width:70,auto:false},
			{field:'PatientID',title:'PatientID',width:80,hidden: true},
			{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
			{field:'mradm',title:'mradm',width:80,hidden: true},
			{field:'PAPMINO',title:'登记号',width:100},  
			{field:'PAPMIName',title:'姓名',width:80},
			{field:'PAPMISex',title:'性别',width:50},
			{field:'PAPMIAge',title:'年龄',width:50},
			{field:'PAPMIDOB',title:'出生日期',width:100},
			{field:'Diagnosis',title:'诊断',width:150},
			{field:'DocAduit',title:'审核医生',width:80},
			{field:'DocActive',title:'医生审核结果',width:100},
			{field:'DocRemark',title:'医生备注',width:120},
			{field:'DocReason',title:'医生不通过原因',width:120},
			{field:'NurseAduit',title:'审核护士',width:80},
			{field:'NurseActive',title:'护士审核结果',width:100},
			{field:'NurseRemark',title:'护士备注',width:120},
			{field:'NurseReason',title:'护士不通过原因',width:120},
			{field:'NurseBed',title:'期望住院床位',width:95},
			{field:'NurseBedDate',title:'期望住院日期',width:100},
   		 ]]
   		var ToolBar = [{
            text: '审核',
            iconCls: 'icon-ok',
            handler: function() { 
	            var row=PageLogicObj.m_patientListTabDataGrid.datagrid('getSelections');
				if ((!row)||(row.length==0)){
					$.messager.alert("提示","请选择需要审核病人!");
					return false;
				}
				if ((row.length!=1)){
					$.messager.alert("提示","请选择一个需要审核病人!");
					return false;
				}else{
					var OneEpisodeID=row[0].EpisodeID
					InitOneNurseAgree(OneEpisodeID)
				}
				if ((row[0].DocActive=="")||(row[0].DocActive=="不通过")){
					$.messager.alert("提示","请选择医生审核通过的病人!");
					return false;
				}
				PageLogicObj.AllNurse=0
	            $('#NurseAgree-dialog').window('open'); 
            }
        },{
            text: '批量审核',
            iconCls: 'icon-ok',
            handler: function() { 
            var row=PageLogicObj.m_patientListTabDataGrid.datagrid('getSelections');
			if ((!row)||(row.length==0)){
				$.messager.alert("提示","请选择需要审核病人!");
				return false;
			}
			ClearNurseAgree();
			PageLogicObj.AllNurse=1
			if (PageLogicObj.AllNurse==1){
				$("#NurseBedtr").hide();
				$("#NurseBedlabletr").hide();
				$("#NurseBedlable").hide();
				$('#NurseBed').next(".combo").hide();
				//$HUI.datebox("#NurseBedDate").show();
				$("#NurseBedDatelable").hide();
				$('#NurseBedDate').next(".combo").hide();
				}
            $('#NurseAgree-dialog').window('open'); 
            }
        }
		]
		var singleSelectFlag=false
	}else if(ServerObj.MasterType=="Cash"){
		var Columns=[[ 
			{field:'Check',title:'选择',checkbox:'true',align:'center',width:70,auto:false},
			{field:'PatientID',title:'PatientID',width:80,hidden: true},
			{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
			{field:'mradm',title:'mradm',width:80,hidden: true},
			{field:'PAPMINO',title:'登记号',width:100},  
			{field:'PAPMIName',title:'姓名',width:80},
			{field:'PAPMISex',title:'性别',width:50},
			{field:'PAPMIAge',title:'年龄',width:50},
			{field:'PAPMIDOB',title:'出生日期',width:100},
			{field:'Diagnosis',title:'诊断',width:150},
			{field:'DocAduit',title:'审核医生',width:80},
			{field:'DocActive',title:'医生审核结果',width:100},
			{field:'DocRemark',title:'医生备注',width:120},
			{field:'DocReason',title:'医生不通过原因',width:120},
			{field:'NurseAduit',title:'审核护士',width:80},
			{field:'NurseActive',title:'护士审核结果',width:100},
			{field:'NurseRemark',title:'护士备注',width:120},
			{field:'NurseReason',title:'护士不通过原因',width:120},
			{field:'NurseBed',title:'期望住院床位',width:95},
			{field:'NurseBedDate',title:'期望住院日期',width:120},
			{field:'warddr',title:'warddr',width:80,hidden: true},
			{field:'admloc',title:'admloc',width:80,hidden: true},
   		 ]]
   		var ToolBar = [{
            text: '办理住院',
            iconCls: 'icon-edit',
            handler: function() {
	             var row=PageLogicObj.m_patientListTabDataGrid.datagrid('getSelections');
				if ((!row)||(row.length==0)){
					$.messager.alert("提示","请选择需要办理住院病人!");
					return false;
				}
				if ((row.length!=1)){
					$.messager.alert("提示","请选择一个需要办理住院病人!");
					return false;
				}
				if (row[0].NurseActive==""){
						$.messager.alert("提示","护士未审核,不能修改办理住院!");
						return false;
				}
				if (row[0].NurseActive!="通过"){
						$.messager.alert("提示","护士审核不通过,不能修改办理住院!");
						return false;
				}
				if (row[0].DocActive==""){
						$.messager.alert("提示","医生未审核,不能修改办理住院!");
						return false;
				}
				if (row[0].DocActive!="通过"){
						$.messager.alert("提示","医生审核不通过,不能修改办理住院!");
						return false;
				}
				var OneEpisodeID=row[0].EpisodeID
				var sessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID'];
				var rtn=$.cm({
					ClassName:"web.DHCBillPreIPAdmTrans",
					MethodName:"AdmTrans",
					episodeId:OneEpisodeID, transType:"I", 
					 deptId:row[0].admloc, wardId :row[0].warddr, norOperFlag:"", sessionStr:sessionStr, 
					dataType:"text"
				},false); 
				if (rtn.split("^")[0]=0){
					$.messager.alert("提示",rtn.split("^")[1]);	
				}else{
					$.messager.alert("提示",rtn.split("^")[1]);
					} 
				patientListTabDataGridLoad()
            }
        }
		]
		var singleSelectFlag=true
	}
	var patientListTabDataGrid=$("#patientListData").datagrid({
		fit : true,
		border : false,
		striped : true,
		rownumbers:true,
		singleSelect : singleSelectFlag,
		//fitColumns : true,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'EpisodeID',
		columns :Columns,
		toolbar:ToolBar,
		onSelect:function(index, row){
		},
		onBeforeSelect:function(index, row){
			
		}
	});
	return patientListTabDataGrid;
}
function patientListTabDataGridLoad(){
	var DocType="",NurseType="",CashType=""
	var DocType=$("input[name='DocSearch']:checked").val();
	var NurseType=$("input[name='NurseSearch']:checked").val();
	var CashType=$("input[name='CashSearch']:checked").val();
	$.q({
	    ClassName : "web.DHCDocIPBookPreAditu",
	    QueryName : "PrePatientList",
	    userID : session['LOGON.USERID'],
	    locID:session['LOGON.CTLOCID'],
	    PatNo:$("#patientNo").val(),
	    PatientName:$("#patientName").val(),
	    masterType:ServerObj.MasterType,
	    DocType:DocType,
	    NurseType:NurseType,
	    CashType:CashType,
	    HospID:session['LOGON.HOSPID'],
	    Pagerows:PageLogicObj.m_patientListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_patientListTabDataGrid.datagrid("uncheckAll");
		PageLogicObj.m_patientListTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		//PageLogicObj.m_patientListTabDataGrid.datagrid("uncheckAll");
	}); 
}
function ShowLabReport(EpisodeID,PatientID, Mradm){
	websys_showModal({
		url:"dhcapp.seepatlis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+Mradm,
		title:$g('检验结果'),
		iconCls:'icon-w-paper',
		width:'95%',height:'95%',
	});
}
function ShowExamReport(EpisodeID,PatientID, Mradm){
	websys_showModal({
		url:"dhcapp.inspectrs.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+Mradm,
		title:$g('检查结果'),
		iconCls:'icon-w-paper',
		width:'95%',height:'95%',
	});
}
function ShowOrder(EpisodeID,PatientID, Mradm){
	websys_showModal({
		url:"oeorder.ipbook.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+Mradm+"&FixedEpisodeID="+EpisodeID,
		title:$g('医嘱录入'),
		iconCls:'icon-w-paper',
		width:'95%',height:'95%',
		onClose: function() {
           //解除患者锁
    	   tkMakeServerCall("web.DHCDocOrderCommon","OrderEntryClearLock");
        }
	});
}
function ClearDocAgree(){
	$HUI.radio("#DocAgreeYes").setValue(false);
	$HUI.radio("#DocAgreeNo").setValue(false);
	$("#DocReason").hide();
	$("#DocReasonlabe").hide();
	$("#DocMark").val("");
	$("#DocReason").val("");
}
function InitOneDocAgree(EpisodeID){
	$cm({
		ClassName:"web.DHCDocIPBookPreAditu",
		MethodName:"ShowDocAgree",
		EpisodeID:EpisodeID,
		dataType:"text"
	},function(rtn){
		if (rtn!=""){
			$HUI.radio("#DocAgreeYes,#DocAgreeNo").setValue(false);
			var Arrayrtn=rtn.split(String.fromCharCode(1))
			if (Arrayrtn[2]=="Y"){
				$HUI.checkbox("#DocAgreeYes").setValue(true);
			}else{
				$HUI.checkbox("#DocAgreeNo").setValue(true);
			}
			$("#DocMark").val(Arrayrtn[5]);
			$("#DocReason").val(Arrayrtn[6]);
		}else{
			ClearDocAgree();
		}
	})
}
function SaveDocAgree(){
	var row=PageLogicObj.m_patientListTabDataGrid.datagrid('getSelections');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要审核病人!");
		return false;
	}
	var EpiosdeStr=""
	for (var i=0;i<row.length;i++){
		if (EpiosdeStr==""){EpiosdeStr=row[i].EpisodeID}else{EpiosdeStr=EpiosdeStr+"^"+row[i].EpisodeID}
		
	}
	var DocMark=$("#DocMark").val();
	var DocReason=$("#DocReason").val();
	var Active=$("input[name='DocAgree']:checked").val();
	if ((Active=="")||(!Active)){
		$.messager.alert("提示","请选择需要通过或者不通过!");
		return false;
	}
	if (Active=="Y") DocReason="";
	if ((Active=="N")&&(DocReason=="")) {
		$.messager.alert("提示","请填写不通过原因!","info",function(){
			$("#DocReason").focus();
		});
		return false;
	}
	var rtn=$.cm({
		ClassName:"web.DHCDocIPBookPreAditu",
		MethodName:"SaveDocAgreeMulit",
		EpisodeStr:EpiosdeStr, AdituDoc:session['LOGON.USERID'], 
		Active:Active, Reason :DocReason, ReMark:DocMark,
		dataType:"text"
	},false);
	if (rtn==0){
		$('#DocAgree-dialog').window('close'); 
		patientListTabDataGridLoad()
	}else{
		$.messager.alert("提示",rtn);	
	}
}
function ClearNurseAgree(){
	$HUI.radio("#NurseAgreeYes").setValue(false);
	$HUI.radio("#NurseAgreeNo").setValue(false);
	$("#NurseReason").hide();
	$("#NurseReasonlabe").hide();
	$("#NurseReasontr").hide();
	$("#NurseMark").val("");
	$("#NurseReason").val("");
	$("#NurseBedlable").show();
	$('#NurseBed').next(".combo").show();
	//$HUI.datebox("#NurseBedDate").show();
	$("#NurseBedDatelable").show();
	$('#NurseBedDate').next(".combo").show();
	$HUI.combobox("#NurseBed").setValue("");	
	$HUI.datebox("#NurseBedDate").setValue("");  	
}
function InitOneNurseAgree(EpisodeID){
	$cm({
		ClassName:"web.DHCDocIPBookPreAditu",
		MethodName:"ShowNurseAgree",
		EpisodeID:EpisodeID,
		dataType:"text"
	},function(rtn){
		if (rtn!=""){
			var Arrayrtn=rtn.split(String.fromCharCode(1))
			if (Arrayrtn[2]=="Y"){
				$HUI.radio("#NurseAgreeYes").setValue(true);
			}else{
				$HUI.radio("#NurseAgreeNo").setValue(true);
			}
			NurseAgreeCheckChange();
			$("#NurseMark").val(Arrayrtn[5]);
			$("#NurseReason").val(Arrayrtn[6]);
			$HUI.combobox("#NurseBed").setValue(Arrayrtn[8]);	
			$HUI.datebox("#NurseBedDate").setValue(Arrayrtn[7]);  	
		}else{
			ClearNurseAgree();
		}
	})
}
function SaveNurseAgree(){
	var row=PageLogicObj.m_patientListTabDataGrid.datagrid('getSelections');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要审核病人!");
		return false;
	}
	var EpiosdeStr=""
	for (var i=0;i<row.length;i++){
		if (EpiosdeStr==""){EpiosdeStr=row[i].EpisodeID}else{EpiosdeStr=EpiosdeStr+"^"+row[i].EpisodeID}
		
	}
	var NurseMark=$("#NurseMark").val();
	var NurseReason=$("#NurseReason").val();
	var Active=$("input[name='NurseAgree']:checked").val();
	if ((Active=="")||(!Active)){
		$.messager.alert("提示","请选择需要通过或者不通过!");
		return false;
	}
	if ((Active=="Y")) NurseReason="";
	if ((Active=="N")&&(NurseReason=="")) {
		$.messager.alert("提示","请填写不通过原因!","info",function(){
			$("#NurseReason").focus();
		});
		return false;
	}
	var NurseBed=$HUI.combobox("#NurseBed").getValue(); 
	var NurseBedDate =$HUI.datebox("#NurseBedDate").getValue(); 
	var rtn=$.cm({
		ClassName:"web.DHCDocIPBookPreAditu",
		MethodName:"SaveNurseAgreeMulit",
		EpisodeStr:EpiosdeStr, AdituNurse:session['LOGON.USERID'], 
		 Active:Active, Reason :NurseReason, ReMark:NurseMark, BedID:NurseBed, PreInDate:NurseBedDate,
		dataType:"text"
	},false);
	if (rtn==0){
		$('#NurseAgree-dialog').window('close'); 
		patientListTabDataGridLoad()
	}else{
		$.messager.alert("提示",rtn);	
	}
}
function setpatientNoLength(){
	var patientNo = $("#patientNo").val();
	if (patientNo != '') {
		for (var i=(10-patientNo.length-1); i>=0; i--){
			patientNo ="0"+ patientNo;
		}
	}
	$("#patientNo").val(patientNo);
	patientListTabDataGridLoad();
}
function NurseAgreeCheckChange(){
	var NurseAgree=$("input[name='NurseAgree']:checked").val();
	if (NurseAgree=="Y"){
    	$("#NurseReason").hide();$("#NurseReasonlabe").hide();
    	$("#NurseReasontr").hide();
    	if (PageLogicObj.AllNurse==0){
	    	$("#NurseBedlabletr").show();
			$("#NurseBedlable").show();
			$("#NurseBedtr").show();
			$('#NurseBed').next(".combo").show();
			//$HUI.datebox("#NurseBedDate").show();
			$("#NurseBedDatelable").show();
			$('#NurseBedDate').next(".combo").show();}
	}else{
    	$("#NurseReason").show();$("#NurseReasonlabe").show();
    	$("#NurseReasontr").show();
		if (PageLogicObj.AllNurse==0){
			$("#NurseBedlabletr").hide();
			$("#NurseBedtr").hide();
			$("#NurseBedlable").hide();
			$('#NurseBed').next(".combo").hide();
			//$HUI.datebox("#NurseBedDate").hide();
			$("#NurseBedDatelable").hide();
			$('#NurseBedDate').next(".combo").hide();
		}
	}
}