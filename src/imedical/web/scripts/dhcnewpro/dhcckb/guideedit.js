var parref = "";
var drugid="";
var drugidnew="";
var IsEnableValue="",LevelFlagValue="",KnowSourceValue="",IsEnableText="",LevelFlagText="",KnowSourceText="",RuleId="";
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "ModelFlag" 	// ʵ����(��������ֵ)
var queryType = "drugType";	
var dictionType="dictionType";
var ActiveArray = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
var LastPaNodeId="";		//�ϼ���id

function initPageDefault(){
	initCombobox();		// ��ʼ��combobox
	initButton();
	initTree();
	initdicTable();		// ��ʼ��ҩƷ��Ʒ���б�
	initdictionTable();
}
///��Ʒҩ ҩƷ����
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}
///ͨ��ҩ ҩƷ����
function InitdictionType(){	
	var drugType = getParam("dictionType");	
	return drugType;
}
function initButton(){
	$("#find").bind("click",QueryDicList);	// ��ѯ��Ʒ��
	$("#reset").bind("click",ExportReset);	// ���� qnp 2021/07/13
	$("#findto").bind("click",QueryDicListnew);	// ��ѯͨ����
	$("#resetto").bind("click",ExportResetnew);	// ����ͨ��
	$("#btnAdd").bind('click',function(){
		SaveRule()
	});										// ����
	/* $("#btnUpd").bind('click',function(){
		SaveRule()
	});										// �޸� */
	$("#btnDel").bind("click",DeleteRule);	// ɾ��
	$("#btnRel").bind("click",RelodePage);	// ����
	
}
function initTree(){
	$('#ruleTree').tree({
    	url:LINK_CSP+'?ClassName=web.DHCCKBGuideEdit&MethodName=GetDrugLibraryTree'+"&userInfo="+LoginInfo,
    	lines:true,
		animate:true,
		dnd:true,
		checkbox:true,
		onClick:function(node){
			RuleId=node.id;
			LoadRightValue(node)
	    },
	    onBeforeDrag:function(data){
		   /// ��קǰ�¼�������false�������ƶ��˽ڵ�
		   var node=$(this).tree('getSelected');
		   if (node === null){return;} 
		   var isLeaf=$(this).tree('isLeaf',node.target);
		   if(isLeaf==false){return false;}
		},
	    onBeforeDrop:function(target,source){         
�������� 	// ���϶�һ���ڵ�֮ǰ������
			var SouParNode = $(this).tree('getParent',source.target);
			LastPaNodeId=SouParNode.id
            var targetNode = $(this).tree('getNode',target);
            var isLeaf=$(this).tree('isLeaf',targetNode.target);
		    if(isLeaf==false){return false;}
		    var ParNodeText=""
		    if (targetNode.hasOwnProperty("ruleId")){
				var ParNode = $(this).tree('getParent',target);	
				ParNodeText=ParNode.text;	    
			}else{
				ParNodeText=targetNode.text;
			}		    
		  
		    var tartext=source.text.split(">")[1];
            if(confirm("ȷ�ϰ� : "+tartext+" �ӣ�"+SouParNode.text+" �ڵ���µ� : "+ParNodeText+" �ڵ���?"))
                return true;                                                
                return false;
        },
	    onDrop:function(target,source,operate){        
        	// ���������Ч���� �϶��󴥷����̨���� ���϶��ڵ���µ�Ŀ��ڵ��¡�
            var targetNode = $(this).tree('getNode',target);
            var ParNode = $(this).tree('getParent',target);
            var ParNodeId="";
           /*  if(ParNode==null){
	            ParNodeId=targetNode.id;
	        }else{
		        ParNodeId=ParNode.id;
		    } */
		    if (targetNode.hasOwnProperty("ruleId")){
				ParNodeId =  ParNode.id;
			}else{
				ParNodeId=targetNode.id;
			}		    
		    
            runClassMethod("web.DHCCKBRuleIndex","DragRule",{"RuleId":source.id,"LastCatId":LastPaNodeId,"NewCatId":ParNodeId},
            	function(data){
	            	if(data==0){
		            	$.messager.popover({msg: '�ƶ��ɹ���',type:'success',timeout: 1000});
		            	$("#ruleTree").tree('reload');
		            	return false;
		           	}else{
			           	if(data==-1){
				           	$.messager.popover({msg: '�˹����Ѵ��ڣ�',type:'success',timeout: 1000});
		            		//$("#ruleTree").tree('reload');
		            		return false;
				        }else{
					        $.messager.popover({msg: '�ƶ�ʧ�ܣ�',type:'success',timeout: 1000});
		            		//$("#ruleTree").tree('reload');
		            		return false;
					    }
			        }
	        })
            
        }
	     
	});
}
///��Ʒҩ��ѯ
function initdicTable(){
	
	var hospId = $HUI.combobox("#hospId").getValue();
	//var parVale = $HUI.combobox("#dicType").getValue();	
	$('#dicTable').datagrid({
		toolbar:"#toolbar", //var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+parref+"&params="+params;
		url:$URL+"?ClassName=web.DHCCKBGuideEdit&MethodName=GetDicInstanceByParref&parref="+parref+"&params="+"&hospId="+hospId+"&existGuide=",
		//url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+DrugData,
		columns:[[ 
		/* 	{field:'ID',hidden:true},
			{field:'CDParrefDesc',title:'����',width:100,align:'center'},		
			{field:'CDCode',title:'����',align:'center',hidden:true},
			{field:'CDDesc',title:'ҩƷ����',width:350,align:'left'} */
			{field:'dicID',title:'rowid',hidden:true},
			{field:'parref',title:'���ڵ�id',width:100,align:'left',hidden:true},
			{field:'parrefDesc',title:'����',width:100,align:'left'},
			{field:'dicCode',title:'����',width:200,align:'left',hidden:true},
			{field:'dicDesc',title:'����',width:350,align:'left'},
			{field:'Operating',title:'����',width:60,align:'center',formatter:SetCellOper}
	
		 ]],
		title:"ҩƷ�б�",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper', 
		border:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],
		onClickRow:  function (rowIndex, rowData) {
			//$('#indicTable').datagrid('load', {dic: rowData.ID});
			//$('#dirTable').datagrid('load', {dic: rowData.ID});
			dataGridDBClick(rowData);
			drugidnew=rowData.dicID;
			reloadTree();
			RelodePage();
        },
        onLoadSuccess:function(data){
	        if(data.rows.length>0){
				//dataGridDBClick(data.rows[0])
		    }
	    },
        displayMsg: '��{total}��¼'
	});
		
}	
///ͨ��ҩ��ѯ
function initdictionTable(){
	$('#comTable').datagrid({
		toolbar:"#toolbarto", //var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+parref+"&params="+params;
		url:$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+"78200"+"&params="+"^78200"+"&drugType="+InitdictionType()+"&hospId="+"&queryType="+dictionType,
		//url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+DrugData,
		columns:[[ 
		/* 	{field:'ID',hidden:true},
			{field:'CDParrefDesc',title:'����',width:100,align:'center'},		
			{field:'CDCode',title:'����',align:'center',hidden:true},
			{field:'CDDesc',title:'ҩƷ����',width:350,align:'left'} */
			{field:'dicID',title:'rowid',hidden:true},
			{field:'parref',title:'���ڵ�id',width:100,align:'left',hidden:true},
			{field:'parrefDesc',title:'����',width:100,align:'left'},
			{field:'dicCode',title:'����',width:200,align:'left',hidden:true},
			{field:'dicDesc',title:'����',width:350,align:'left'}
	
		 ]],
		title:"ҩƷ�б�",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper', 
		border:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],
		onClickRow:  function (rowIndex, rowData) {
			//$('#indicTable').datagrid('load', {dic: rowData.ID});
			//$('#dirTable').datagrid('load', {dic: rowData.ID});
			dataGridDBClick(rowData);
			reloadTree();
			RelodePage();
        },
        onLoadSuccess:function(data){
	        if(data.rows.length>0){
				//dataGridDBClick(data.rows[0])
		    }
	    },
        displayMsg: '��{total}��¼'
	});
		
}
function SaveRule(){
	
	if(drugidnew==""){
		$.messager.alert("��ʾ","��ѡ��ҩƷ!",'warning'); 
		return;
	}else{
	var DrugPrintId=serverCall("web.DHCCKBGuideEdit","GetDrugPrintId","");
	var LevelFlagId=serverCall("web.DHCCKBGuideEdit","GetLevelFlagId","");
	var WarnMessageId=serverCall("web.DHCCKBGuideEdit","GetWarnMessageId","");
	var KnowSourceId=serverCall("web.DHCCKBGuideEdit","GetKnowSourceId","");
	var IsEnableValue=$("#IsEnable").combobox('getValue');
	var IsEnableText=$("#IsEnable").combobox('getText');
	var LevelFlagValue=$("#LevelFlag").combobox('getValue');
	var LevelFlagText=$("#LevelFlag").combobox('getText');
	
	var KnowSourceValue=$("#KnowSource").combobox('getValue');
	var KnowSourceText=$("#KnowSource").combobox('getText');
	
	var WarnMessage=$("#Descript").val();
	/* ������ */
	var AssignListFir={
         "value":{
         	"_ruleData":"0",
         	"_const-category":"undefined",
         	"_const":LevelFlagValue,//������ID
         	"_const-label":LevelFlagText,//����������
          	"_type":"Constant"
                  },
         "_varCategory":"ҩƷ���",
         "_ruleData":"0",
         "_varCategoryId":DrugPrintId,
         "_var":LevelFlagId,
         "_varLabel":"������",
         "_datatype":"String",
         "_type":"variable"
                };
    /* ��ʾ��Ϣ */             
	var AssignListSec={
         "value":{
         	"_ruleData":"0",
         	"_content":WarnMessage,//����
         	"_type":"Input"
                  },
         "_varCategory":"ҩƷ���",
         "_ruleData":"0",
         "_varCategoryId":DrugPrintId,
         "_var":WarnMessageId,
         "_varLabel":"��ʾ��Ϣ",
         "_datatype":"String",
         "_type":"variable"
                };
    /* ֪ʶ��Դ */
    var AssignListFif={
         "value":{
         	"_ruleData":"0",
         	"_const-category":"undefined",
         	"_const":KnowSourceValue,
         	"_const-label":KnowSourceText,
          	"_type":"Constant"
                  },
         "_varCategory":"ҩƷ���",
         "_ruleData":"0",
         "_varCategoryId":DrugPrintId,
         "_var":KnowSourceId,
         "_varLabel":"֪ʶ��Դ",
         "_datatype":"String",
         "_type":"variable"
                };
    var param=[];
    param.push(AssignListFir);
    param.push(AssignListSec);
    /* param.push(AssignListThi);
    param.push(AssignListFou); */
    param.push(AssignListFif);
    var RuleData={};
    RuleData["remark"]="";
    RuleData["if"]={"and":{}};
    RuleData["then"]={"var-assign":param};
    RuleData["else"]="";
    RuleData["_name"]="rule";
    var RuleJson={};
	RuleJson["rule"]=RuleData;
	var rulejson=JSON.stringify(RuleJson);
	var node = $("#ruleTree").tree('getSelected');
	var GuideEditId=serverCall("web.DHCCKBGuideEdit","GetGuideEditId","");
	if (node==null){
		$.messager.alert("��ʾ","����ѡ��Ŀ¼�еĹ���",'warning');
		return;
		}else{
		if (node.ruleId==null){
		dicStr=drugidnew+"^"+node.id
		RuleId=0
	}else{
		var parentnode=$("#ruleTree").tree('getParent',node.target);
		dicStr=parentnode.id+"^"+drugidnew
		RuleId=node.ruleId
		}
	var data={
	   	ruleId:RuleId,
	   	status:IsEnableValue,
	   	/* json:JSON.stringify(RuleJson), */
	   	json:RuleJson,
	   	LgUserId:LgUserID,
		dicStr:dicStr,
		loginInfo:LoginInfo	
	};
	console.log(data);	
	if((WarnMessage!="")&&(LevelFlagValue!="")){
		
		/* $.post(
 		"web.DHCCKBRuleSave.cls",
   		{json:rulejson,
		 dicStr:dicStr,
		 ruleId:RuleId,
		 LgUserId:LgUserID,
		 status:IsEnableValue,
		 loginInfo:LoginInfo	
		 },function(data){
	     	if(data.code>0){
	         	$.messager.alert("��ʾ","����ɹ���"); 
	         	reloadTree();
		    }else{
		        //window._setDirty()
		        $.messager.alert("��ʾ","����ʧ�ܣ�"+data.msg);
		        reloadTree() ;
			}
	},"json"); */
	
	runClassMethod("web.DHCCKBRuleSave","save",
		{"json": rulejson,
		 "dicStr":dicStr, //Ŀ¼��ҩƷID
		 "ruleId":RuleId,
		 "LgUserId":LgUserID,
		 "status":IsEnableValue, 
		 "loginInfo":LoginInfo
		 }, function(data){
	     	if(data>0){
	         	$.messager.alert("��ʾ","����ɹ���",'success'); 
	         	reloadTree();
	         	RelodePage();
		    }else{
		        $.messager.alert("��ʾ","����ʧ�ܣ�"+data,'error');
		        reloadTree() ;
		        RelodePage();
			}
	},"json");
	}else{
		$.messager.alert("��ʾ","����,��������Ϊ��",'warning');
		return;
		};	
			
	};
	
	};
}

function DeleteRule(){
	var node = $("#ruleTree").tree('getSelected');
	if(node.ruleId!=undefined){
			$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����", function (res) {
				/// ��ʾ�Ƿ�ɾ��
				if (res) {
					runClassMethod("web.DHCCKBRuleSave","RemoveRule",{"ruleId":node.ruleId},function(jsonString){
						reloadTree();
						RelodePage();
					});
				}
			})	
    }else{
		$.messager.alert("��ʾ","��ѡ�й���!");   
	}

}
function LoadRightValue(node){
	if(node.ruleId!=null){
		RelodePage()
		var RuleData=serverCall("web.DHCCKBGuideEdit","GetRuleData",{"RuleId":node.ruleId});	
		var RuleDataArr = RuleData.split('^');
		for (var i=0;i < RuleDataArr.length;i++){
			var RuleDet=RuleDataArr[i];
			var RuleDetArr = RuleDet.split('&');
			var RuleDetType=RuleDetArr[0];
			var RuleDetValue=RuleDetArr[1];
			var RuleDetText=RuleDetArr[2];
			if (RuleDetType=="IsEnable"){
				if (RuleDetText=="Release"){
					$HUI.combobox("#IsEnable").setValue("Release");
					$HUI.combobox("#IsEnable").setText("��");
				}else if(RuleDetText=="CancelRelease"){
					$HUI.combobox("#IsEnable").setValue("CancelRelease");
					$HUI.combobox("#IsEnable").setText("��");
					}
			}else if(RuleDetType=="LevelFlag"){
				
				$HUI.combobox("#LevelFlag").setValue(RuleDetValue);
				$HUI.combobox("#LevelFlag").setText(RuleDetText);
			}else if(RuleDetType=="KnowSource"){
				
				$HUI.combobox("#KnowSource").setValue(RuleDetValue);
				$HUI.combobox("#KnowSource").setText(RuleDetText);
			}else if(RuleDetType=="WarnMessage"){
				$("#Descript").val(RuleDetText);
				}
		}	
	}else{
		RelodePage()
		}
	
	}
function RelodePage(){
	/*
	$HUI.combobox("#IsEnable").setValue("");
	$HUI.combobox("#IsEnable").setText("");
	$HUI.combobox("#LevelFlag").setValue("");
	$HUI.combobox("#LevelFlag").setText("");
	$HUI.combobox("#KnowSource").setValue("");
	$HUI.combobox("#KnowSource").setText("");
	*/
	$("#Descript").val("");	
	$HUI.combobox("#IsEnable").setValue("Release");
	$HUI.combobox("#LevelFlag").setValue(tipsId); // Ĭ����ʾ
	$HUI.combobox("#KnowSource").setValue(knowId); // Ĭ��˵����
	$HUI.combobox("#IsEnable").setText("��");
	$HUI.combobox("#LevelFlag").setText("��ʾ");	
	$HUI.combobox("#KnowSource").setText("ҩƷ˵����");
	}

function QueryDicList(){
	var params = $HUI.searchbox("#queryCode").getValue();
	var hospId = $HUI.combobox("#hospId").getValue();
	var existGuide = $HUI.checkbox("#existGuide").getValue(); 
	existGuide = existGuide==false?"":existGuide;
	$('#dicTable').datagrid('load',{	
		parref:parref,
		params:params,
		hospId:hospId,	
		existGuide:existGuide
		//id:DrugData,
		//parDesc:params	
	}); 
}
function QueryDicListnew(){
	var params = $HUI.searchbox("#queryCodenew").getValue()+"^"+"78200"
	var hospId = $HUI.combobox("#hospId").getValue();
	$('#comTable').datagrid('load',{
		extraAttr:"DataSource",
		parref:"78200",
		params:params,
		hospId:hospId,
		queryType:dictionType
		//id:DrugData,
		//parDesc:params	
	}); 
}
/// ���ò�ѯ����
function ExportReset(){
	$HUI.searchbox("#queryCode").setValue("");
	$HUI.combobox("#dicType").setValue("");
	$HUI.combobox("#hospId").setValue("");
	$HUI.checkbox("#existGuide").setValue(false); 
}

/// ����
function ExportResetnew(){
	$HUI.searchbox("#queryCodenew").setValue("");
}

	
function dataGridDBClick(rowData){
		$("#ruleTree").tree("options").url=LINK_CSP+'?ClassName=web.DHCCKBGuideEdit&MethodName=GetDrugLibraryTree&dic='+rowData.dicID+'&userInfo='+LoginInfo;
		$('#ruleTree').tree('reload');
}
function dataGridDBClicknew(rowData){
		$('#form-save').form('reload');
}
function reloadTree(){
	$("#ruleTree").tree("options").url=LINK_CSP+'?ClassName=web.DHCCKBGuideEdit&MethodName=GetDrugLibraryTree&dic='+drugidnew+'&userInfo='+LoginInfo;
	$('#ruleTree').tree('reload');
	}

/// ��ʼ��combobox
function initCombobox(){
	/// ��ʼ�����������
	var option = {
		panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	        parref = option.value;
	       	QueryDicList();
	    },
		loadFilter:function(data){                
                for(var i = 0; i < data.length; i++){
                    if(data[i].text != "��ҩ" && data[i].text != "�г�ҩ" && data[i].text != "��ҩ��Ƭ"){
                        data.splice(i,1);
                        //����splice������data�е�ĳ����ŵ�ֵɾ���ˣ�������������˳���������ǰ�������-1,�ᵼ�²�������δ����ɸѡ
                        i--;
                    }
                }
                return data;
        },
       onLoadSuccess: function (data) {
	        var data = $("#dicType").combobox("getData");	// Ĭ��ѡ���һ��
	        if (data && data.length > 0) {
	            $("#dicType").combobox("setValue", data[0].value);
	            parref = data[0].value;	
	            //QueryDicList();            
	        }
        }
	}; 	
	var url = $URL +"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue+"&drugType="+InitDrugType();
	//var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("dicType",url,'',option).init(); 	
	
	$('#IsEnable').combobox({
		valueField:'value',
		textField:'text',
		mode:'remote',
		enterNullValueClear:false,
		blurValidValue:true,
		onSelect:function(option){
		/* IsEnableValue=option.value
		IsEnableText=option.text */
		},
		onShowPanel:function(){
		var data=[{"value":"Release","text":"��"},{"value":"CancelRelease","text":"��"}];
		$('#IsEnable').combobox('loadData',data);	
		}
	})
	$('#IsEnable').combobox("setText","��"); // Ĭ������
	$('#IsEnable').combobox("setValue","Release"); // Ĭ������
	
	$('#LevelFlag').combobox({
		valueField:'value',
		textField:'text',
		mode:'remote',
		enterNullValueClear:false,
		blurValidValue:true,
		onSelect:function(option){
		/* LevelFlagValue=option.value;
		LevelFlagText=option.text */
		},
		onShowPanel:function(){
		var unitUrl=$URL+"?ClassName=web.DHCCKBGuideEdit&MethodName=GetLevelFlagComboxData&q="+'';
		$('#LevelFlag').combobox('reload',unitUrl);	
		}
	})	
	$('#LevelFlag').combobox("setValue",tipsId); // Ĭ����ʾ
	$('#LevelFlag').combobox("setText","��ʾ"); // Ĭ����ʾ
	
	$('#KnowSource').combobox({
		valueField:'value',
		textField:'text',
		mode:'remote',
		enterNullValueClear:false,
		blurValidValue:true,
		onSelect:function(option){
		/* KnowSourceValue=option.value;
		KnowSourceText=option.text */
		},
		onShowPanel:function(){
		var unitUrl=$URL+"?ClassName=web.DHCCKBGuideEdit&MethodName=GetKnowSourceComboxData&q="+'';
		$('#KnowSource').combobox('reload',unitUrl);	
		}
	})
	$('#KnowSource').combobox("setValue",knowId); // Ĭ��˵����
	$('#KnowSource').combobox("setText","ҩƷ˵����"); // Ĭ��˵����
	
	// Ժ��
  	var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
  	$HUI.combobox("#hospId",{
	    url:uniturl,
	    valueField:'value',
		textField:'text',
		panelHeight:"150",
		mode:'remote'				
	})
	
}

///���ò�����ϸ����
function SetCellOper(value, rowData, rowIndex){

	var btn = "<img class='mytooltip' title='��ҩָ������' onclick=\"OpenEditWin('"+rowData.dicID+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 

 return btn;  

}

// ��ҩָ��������ܵ���ҳ��
function OpenEditWin(ID){
	
	if($('#guideWin').is(":visible")){return;}  			//���崦�ڴ�״̬,�˳�

	var edithtml = '<div id="guide" class="hisui-textbox" style="height: 300px;"><textarea id="editPanel" class="textbox" style="width:460px;height:290px;margin:10px 10px 10px; 10px;"></textarea></div>';
	$('body').append('<div id="guideWin">'+edithtml+'</div>');
	var myWin = $HUI.dialog("#guideWin",{
        iconCls:'icon-write-order',
        //resizable:true,
        title:'��ҩָ��',
        modal:true,
        width:500,
        height:400,
        buttonAlign : 'center',
        buttons:[{
            text:'����',
            id:'save_btn',
            handler:function(){
	           var msg = $("#editPanel").val();
	           if (msg != ""){
		       	  SaveGuideInfo(ID);
               	  $HUI.dialog("#guideWin").close();        
		       }else{
			   	  $.messager.alert("��ʾ","��¼��ָ����Ϣ",'warning'); 
			   }
                        
            }
        },{
            text:'�ر�',
            handler:function(){  
            	//cleanEidtPanel();                            
                myWin.close(); 
            }
        }],
        onClose:function(){

        },
        onLoad:function(){
	    
	    },
	    onOpen:function(){
	    }
    });
    GetAllGuideInfo(ID);
 	//$("#editPanel").val("");
	$('#guideWin').dialog('center');
}

/// ��ҩָ��������Ϣ
function GetAllGuideInfo(drugId){

	runClassMethod("web.DHCCKBGuideEdit","GetGuideInfo",{"drugId":drugId},function(jsonString){
		$("#editPanel").val(jsonString);
	},"",false);
}

/// ������ҩָ��������Ϣ
function SaveGuideInfo(drugId){

	var msg = $("#editPanel").val();
	runClassMethod("web.DHCCKBGuideEdit","SaveGuideInfo",{"drugId":drugId,"msg":msg,"userInfo":LoginInfo,"ip":ClientIPAdd},function(jsonString){
		if (jsonString != 0){
			$.messager.alert("��ʾ","����ʧ��"+ret,'warning'); 
		}
	},"",false);
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
