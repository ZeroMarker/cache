var LastPaNodeId="";		//�ϼ���id
var drugruleID="",drugID="",num=0;  // xww 2021-08-06 ��ȡҩƷ�͹���id
$(function(){ 
	InitParam(); //xww 2021-08-06 ��ȡ���ֵ����ݹ������ý��洫�����Ĳ���
	initLookUp();
	initTree();
	
})

//xww 2021-08-06
function InitParam(){
	drugruleID = getParam("ruleID");
	drugID = getParam("drugID");
}

function initLookUp(){
       
  //Ŀ¼
	$('#catDesc').combobox({
		url:$URL+'?ClassName=web.DHCCKBRuleIndex&MethodName=QueryCatDic'+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():""),
		valueField: 'value',
		textField: 'text',
		blurValidValue:true
		//editable:false
	})
}

function initTree(){
	$('#ruleTree').tree({
    	url:LINK_CSP+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetDrugLibraryTree&dic='+ModelDic+"&userInfo="+LoginInfo,
    	lines:true,
		animate:true,
		dnd:true,
		checkbox:true,
		onContextMenu: function(e, node){
			
			e.preventDefault();
			$('#ruleTree').tree('select', node.target);
			// ��ʾ��ݲ˵�
			$('#treeMenu').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
		onClick:function(node, checked){
			onClickTreeNode(node);			
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
		    var ParNode = $(this).tree('getParent',target);
		    var ParNodeText=""
		    if(ParNode==null){
			    ParNodeText=targetNode.text;
			}else{
				ParNodeText=ParNode.text;
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
            if(ParNode==null){
	            ParNodeId=targetNode.id;
	        }else{
		        ParNodeId=ParNode.id;
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
            
        },
        formatter:function(node){
	        var img=node.text.split("$c(1)")[0];
	        var desc=node.text.split("$c(1)")[1];
	        if(desc==undefined){desc="";}
			if ((desc!="")&&(desc.length > 30)) {
				var str ="" ;
				str = desc.substring(0, 30) + '......';
				return img+str ;
			} else {
				return img+desc;
			} 
			
		},
        onLoadSuccess:function(node,data){
	      commonAddTreeTitle("ruleTree",data)
	      BindTips();
	      	num=num+1;  //��һ�β��� xww 2021-08-09
	      	if((drugruleID!="")&&(num>1)){
				findRuleKeyWord(drugruleID);
		   		drugruleID="";  //�������գ���ֹ�´���Ȼ���������� xww 2021-08-09
		   }
	    }
	});
	
	
	removeKeyWord();
	getRuleIframe(0)
	var selItem=window.parent.$("#modelTable").datagrid('getSelected');
	var opts = window.parent.$('#modelTable').datagrid('getColumnFields');
	var value="";
	for(var i=0;i<opts.length;i++){
		var colOpt=window.parent.$('#modelTable').datagrid('getColumnOption',opts[i])
		if(colOpt.hidden===false){
			if(value!=""){
				continue;	
			}
			var desc=selItem[colOpt.field].split(">")[1];
			var value=selItem[colOpt.field+"Id"]
			//console.log(value+"^"+desc)
			addKeyWord(value,desc,"");
		}	
	}
}

function onClickTreeNode(node){
		 var ruleId=node.ruleId
		
	     if(ruleId!=undefined){
			findRuleKeyWord(node.id); 
	     }else{
		    ruleId=0;
		    $("#selectKeyWords li a").each(function(index,itm){   //sufan �Ƴ�Ŀ¼ 2020-02-25
				if($(itm).attr("label-type")=="cat"){
					$(this).parent().remove();
				}
			})
		 	addKeyWord(node.id,node.text,"cat");  
		 }
		 var url="dhcckb.rule.editor0.csp?ruleId="+ruleId;
		 if ("undefined"!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken();
		 }
		 $('#ruleFrame').attr('src', url);	
}
function commonAddTreeTitle(domId, nodeData) {
	if (nodeData != null && nodeData != "") {
		for (var index = 0; index < nodeData.length; index++) {
			var operNode = $('#' + domId).tree("find", nodeData[index].id + "");
			$(operNode.target).attr("title", nodeData[index].tiptext);
			commonAddTreeTitle(domId, nodeData[index].children);
		}
}
}
///������ʾ
function BindTips()
{
	// ȥ�� title ����ʾ��
	$(".tree-title").tooltip({
		position:'none',
		onShow:function(){
			$(this).tooltip('tip').css({
			backgroundColor:'rgba(0,0,0,0)'
			});
		}
	})
	var html='<div id="tip" style="max-width:500px;border-radius:5px;display:none;border:1px solid #000;padding: 5px 8px;position:absolute;background-color:rgba(0,0,0,.7);color:#fff;"></div>'
	$('body').append(html);
	/// ����뿪
	$('.tree-title').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// ����ƶ�
	$('.tree-title').on({
		'mousemove':function(){
			var tleft=(event.clientX + 20);
			var title=$(this).parent()[0].title;
			/// tip ��ʾ��λ�ú������趨
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 1
			}).text(title);   // .text()
		}
	})
}

///���ҹ���ؼ���
function findRuleKeyWord(rule){
	$("#selectKeyWords").html("");
	runClassMethod("web.DHCCKBRuleDic","FindRuleKeyWord",{ruleId:rule},function(data){
		$(data).each(function(index,itm){
			addKeyWord(itm.id,itm.text,itm.cat) //hxy 2021-03-26 ""->itm.cat
		})
	},"json")
}

///��ӹؼ���
function addKeyWord(value,title,type){
	var existFlag=0;
	$("#selectKeyWords li a").each(function(index,itm){
		if($(itm).attr("id")==value){
			existFlag=1;
			return false;
		}
	})
	if(existFlag==0){
		if (type==""){
			$("#selectKeyWords").append("<li ><a onClick='removeKeyWordByObj(this)' id="+value+"  title=\""+title+"\">"+title+"</a></li>")
		}else{
			$("#selectKeyWords").append("<li ><a onClick='removeKeyWordByObj(this)' id="+value+"  label-type="+type+" title=\""+title+"\">"+title+"</a></li>")
		}
	}
	
}

function removeKeyWord(){
	$("#selectKeyWords").html("");
}

function getRuleIframe(ruleId){
	var url = "dhcckb.rule.editor0.csp?ruleId="+ruleId;
	if ("undefined"!==typeof websys_getMWToken){
		url += "&MWToken="+websys_getMWToken();
	}
	$('#ruleFrame').attr('src', url); 
}

function lifeCycle(t){
	
	if(t==0){
		$.messager.alert("��ʾ","��ѡ�����","info");
		return;	
	}
	
	var url="dhcckb.rule.life.csp?ruleId="+t;
	if ("undefined"!==typeof websys_getMWToken){
		url += "&MWToken="+websys_getMWToken();
	}
	var content = '<iframe src="' + url + '" width="100%" height="99%" frameborder="0" scrolling="yes"></iframe>';
    
    $('#lifeDia').dialog({
                content: content,
                width:800,
                height:600,
                maximized: false,//Ĭ�����
                modal: false
	});
	$('#lifeDia').dialog('open')
}

function CreateRule(){
	var node = $("#ruleTree").tree('getSelected');
	if(node.ruleId!=undefined){
		$.messager.alert("��ʾ","�����ڹ���������","info");
		return;
	}	
	var ruleId=0,relation=0,dicCode=0;
	dicCode=node.id;
	relation=node.relation;
	addKeyWord(node.id,node.text,"");
	var url="dhcckb.rule.editor0.csp?ruleId="+ruleId+"&relation="+ dicCode+"&dicCode="+relation;
	if ("undefined"!==typeof websys_getMWToken){
		url += "&MWToken="+websys_getMWToken();
	}
	$('#ruleFrame').attr('src', url);	
}

function DeleteRule(){
	//var node = $("#ruleTree").tree('getSelected');
	var node = $("#ruleTree").tree('getChecked');
	var nodeArr = []
	for (i=0;i<node.length;i++){
		nodeArr.push(node[i].ruleId); 
	}
	var nodeStr = nodeArr.join("^");
	///if(node.ruleId!=undefined){
	if(nodeStr!=""){
			$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����", function (res) {
				/// ��ʾ�Ƿ�ɾ��
				if (res) {
					//runClassMethod("web.DHCCKBRuleSave","RemoveRule",{"ruleId":node.ruleId},function(jsonString){
					runClassMethod("web.DHCCKBRuleSave","RemoveRuleAll",{"nodeStr":nodeStr},function(jsonString){
						reloadTree();
					});
				}
			})	
    }else{
		$.messager.alert("��ʾ","��ѡ�й���!","info");   
	}

}

///�ƶ����� sufan 20200212
function MoveRule(){
	$("#ruleMoveWin").show();
	$HUI.combobox("#catDesc").setValue("");	
	var option = {
		iconCls:'icon-w-save',
		modal:true,
		collapsible : false,
		minimizable : false,
		maximizable : false,
		border:true,
		closed:"true"
	};
	var title = "�ƶ�����";		
	new WindowUX(title, 'ruleMoveWin', '400', '125', option).Init();
}

///��ʵ���� sufan 20201105
function VerRule()
{
	var tableName = "DHC_CKBRule";				//����
	//var dicId = node.id;														//��¼id
	var funCode = "confirm";										//��Ȩ���code
	var operator = LgUserID;											//������
	var Scope = "D"
	var ScopeValue = LgHospID;
	var ClientIPAddress = ClientIPAdd;
	var nodes = $('#ruleTree').tree('getChecked');
    var s = '';
	    for (var i = 0; i < nodes.length; i++) {
	        if (s != '')
	            s += '^';
	        s += nodes[i].id;
	    }
    var node = $("#ruleTree").tree('getSelected');
    var dicId = "";	
	    if(s)
	    {
			dicId=s;	    
		}else
		{
			dicId=node.id;	
		}
	runClassMethod("web.DHCCKBWriteLog","InsertLogs",{"DicDr":tableName,"dataDr":dicId,"Function":funCode,"Operator":operator,"OperateDate":"","OperateTime":"","Scope":Scope,"ScopeValue":ScopeValue,"ClientIPAddress":ClientIPAddress},function(ret){
	    if(ret==0)
	    {
		    $("#ruleTree").tree('reload');
		   }else{
			   $.messager.allert("��ʾ","��ʵʧ�ܣ��������"+ret);
			  }
	},'text',false);
	
	//�޸Ĺ����״̬
	var userInfo=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
	runClassMethod("web.DHCCKBRuleLog","SaveLog",{"ruleId":dicId,"LgUserId":operator,"loginInfo":userInfo,"baseHosp":"������׼�����ֻ�ҽԺ[��Ժ]","Type":"Confirm"},function(ret){
    if(ret>0)
    {
	   // $("#ruleTree").tree('reload');
	   }else{
		   $.messager.allert("��ʾ","������־״̬���ʧ��"+ret);
		  }
	},'text',false);
	
}

///������ʵ shy
function CancelVerRule()
{
	var node = $("#ruleTree").tree('getSelected');
	var tableName = "DHC_CKBRule";				                    //����
	var dicId = node.id;											//��¼id
	var funCode = "cancelconfirm";										//��Ȩ���code
	var operator = LgUserID;										//������
	var Scope = "D"
	var ScopeValue = LgHospID;
	var ClientIPAddress = ClientIPAdd;
	runClassMethod("web.DHCCKBWriteLog","InsertLogs",{"DicDr":tableName,"dataDr":dicId,"Function":funCode,"Operator":operator,"OperateDate":"","OperateTime":"","Scope":Scope,"ScopeValue":ScopeValue,"ClientIPAddress":ClientIPAddress},function(ret){
	    if(ret==0)
	    {
		    $("#ruleTree").tree('reload');
		   }else{
			   $.messager.allert("��ʾ","������ʵʧ�ܣ��������"+ret);
			  }
	},'text',false);
}

///��Ȩ���� Sunhuiyong 20201110
function AuthRule()
{
	var node = $("#ruleTree").tree('getSelected');
	var dicId = node.id;
	var hideFlag=1;								//��ť���ر�ʶ
	var setFlag = "businessAuth";					//��Ȩ��ʶ
	var tableName = "DHC_CKBRule";		        //��Ȩ��
	var dataId = dicId;					       //����Id
	
	if($('#win').is(":visible")){return;}  			//���崦�ڴ�״̬,�˳�
	
	$('body').append('<div id="win"></div>');
	var ifurl = "dhcckb.diclog.csp"+"?HideFlag="+hideFlag+"&DicName="+tableName+"&dataid="+dataId+"&SetFlag="+setFlag+"&ClientIP="+ClientIPAdd+"&TableName="+tableName+"&CloseFlag=1"+"&Operator="+LgUserID;
	if ("undefined"!==typeof websys_getMWToken){
		ifurl += "&MWToken="+websys_getMWToken();
	}
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-w-list',
        title:'��Ȩ',
        modal:true,
        width:700,
        height:460,
        content:"<iframe id='otherdiclog' scrolling='auto' frameborder='0' src='"+ifurl+"' "+"style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
            text:'����',
            id:'save_btn',
            handler:function(){
                GrantAuthItem();                    
            }
        },{
            text:'�ر�',
            handler:function(){                              
                myWin.close(); 
            }
        }]
    });
	$('#win').dialog('center');	
}

function CopyRule()
{
   var dicID=ModelDic;
   var userInfo=LgUserID+"^"+LgCtLocID+"^"+LgProfessID+"^"+LgGroupID+"^"+LgHospID;
   var nodes = $('#ruleTree').tree('getChecked');
            var s = '';
            for (var i = 0; i < nodes.length; i++) {
                if (s != '')
                    s += ',';
                s += nodes[i].id;
            }
            
	$HUI.dialog("#CopyRuleWin").open();
	
	/// ��ʼ��combobox
	var option = {
		//panelHeight:"auto",
		multiple:true,
		selectOnNavigation:false,
		panelHeight:400,
		editable:true,
		//mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
        dicParref = option.value;  //ѡ��ָ���ֵ�id
	    }
	}; 
	if(window.parent.$HUI.combotree('#modelTree').jdata == undefined){
		var mode="";
	}else{
		var mode= window.parent.$HUI.combotree('#modelTree').getValue(); 
	}	
	var url = LINK_CSP+"?ClassName=web.DHCCKBRuleCopy&MethodName=GetDicComboboxList&extraAttr="+"KnowType" +"&extraAttrValue="+"DrugData"+"&mode="+mode+"&indicId="+dicID;;
	new ListCombobox("newDicDrug",url,'',option).init(); 
}

/// ��������/����ȡ������ qunianpeng 2020/2/23
function ReleaseStatus(status){

	var nodes = $('#ruleTree').tree('getChecked');
	if (nodes.length==0){
		$.messager.alert('��ʾ','�빴ѡ��Ҫ�����Ĺ���','info');
		return;
	}
    var ruleIdArr = [];
    for (var i = 0; i < nodes.length; i++) {
       if ((nodes[i].ruleId != undefined)&(nodes[i].ruleId != "")){
		    ruleIdArr.push(nodes[i].ruleId);     
		}        
    }
    var ruleIdStr=ruleIdArr.join("^"); 

	runClassMethod("web.DHCCKBRuleSave","ReleaseStatus",{"ruleIdStr":ruleIdStr,"loginInfo":LoginInfo,"status":status},function(jsonString){
		if (jsonString == 0){
			$.messager.alert('��ʾ','�����ɹ���','info');
		}else if(jsonString != 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}	
		
		$("#ruleTree").tree("options").url=$URL+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetDrugLibraryTree&dic='+ModelDic+'&userInfo='+LoginInfo;
		$('#ruleTree').tree('reload');	
	
	});
}

//sunhuiyong 2021-2-23 �����ƶ�����
function saveMoveRules()
{
	var node = $("#ruleTree").tree('getSelected');  // �����Ǹ��ڵ㣬Ҳ������Ҷ�ӽڵ�
	var ParNode = $('#ruleTree').tree('getParent',node.target);
	var CatId = $HUI.combobox("#catDesc").getValue();
	var checkNodes = $('#ruleTree').tree('getChecked');
	
	var s = '',rulearr = [],ParNodeId="";
	// ѡ��Ŀ¼�ƶ�����,�ƶ�Ŀ¼�����еĹ���(ѡ�е���Ŀ¼)
	if (node.hasOwnProperty("children")){
		ParNodeId = node.id;
		if(checkNodes.length == 0){	// ����ѡ�˹���,���ƶ���ѡ�Ĺ���,�����ƶ�Ŀ¼�����еĹ���
			var nodearr = node.children;
			for (var i = 0; i < nodearr.length; i++){
				rulearr.push(nodearr[i].id);
			}
		}else{
			for (var i = 0; i < checkNodes.length; i++){
				if (checkNodes[i].hasOwnProperty("ruleId")){
					rulearr.push(checkNodes[i].ruleId);
				}				
			}
		}		
	}else{ // (ѡ�е���Ҷ�ӽڵ�)
		ParNodeId = ParNode.id;
		for (var i = 0; i < checkNodes.length; i++){
			if (checkNodes[i].hasOwnProperty("ruleId")){
				rulearr.push(checkNodes[i].ruleId);
			}				
		}		
	}
	rule = rulearr.join(",");
	if ((rule == "")||(ParNodeId == "")){
		$.messager.alert('��ʾ','�빴ѡ��Ҫ�ƶ��Ĺ���','info');
		return;
	}

	runClassMethod("web.DHCCKBRuleIndex","DragRules",{"RuleId":rule,"LastCatId":ParNodeId,"NewCatId":CatId},
            	function(data){
	            	if(data==0){
		            	$.messager.popover({msg: '�ƶ��ɹ���',type:'success',timeout: 1000});
		            	//$("#ruleTree").tree('reload');
		            	$("#ruleTree").tree('remove',node.target);
		            	$("#ruleTree").tree('reload');
		            	closeMoveWin()
		            	return false;
		           	}else{
			           	if(data==-1){
				           	$.messager.popover({msg: '�˹����Ѵ��ڣ�',type:'success',timeout: 1000});
		            		//$("#ruleTree").tree('reload');
		            		closeMoveWin()
		            		return false;
				        }else{
					        $.messager.popover({msg: '�ƶ�ʧ�ܣ�',type:'success',timeout: 1000});
		            		//$("#ruleTree").tree('reload');
		            		closeMoveWin()
		            		return false;
					    }
			        }
	 })
} 
function closeMoveWin(){
	$("#ruleMoveWin").window('close');
}
function reloadTree(){
	$("#ruleTree").tree('reload');
	$("#commonRuleTree").tree('reload');		
	$("#globalRuleTree").tree('reload');		
}

//���ƶ��ѡ�й��� sunhuiyong
function SaveCopyRuleData()
{
	var dicID=ModelDic;
	var userInfo=LgUserID+"^"+LgCtLocID+"^"+LgProfessID+"^"+LgGroupID+"^"+LgHospID;
	var loginInfo=LgUserID+"^"+LgProfessID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
 	var nodes = $('#ruleTree').tree('getChecked');
            var s = '';
            for (var i = 0; i < nodes.length; i++) {
                if (s != '')
                    s += ',';
                s += nodes[i].id;
            }
    var node = $("#ruleTree").tree('getSelected');
	//var rule = node.id;
    var rule="";
    if(s)
    {
		rule=s;	    
	}else
	{
		rule=node.id;	
	}
	var newDicStr="";
    var newDicDrug=$("#newDicDrug").combobox('getValues');
    for(var k=0; k<newDicDrug.length; k++)
    {
		if(newDicStr=="")
		{
			newDicStr=newDicDrug[k];	
		}else{
			newDicStr=newDicStr+"^"+newDicDrug[k];		
		}
	}
    //$.messager.confirm("��ʾ", "����ά����...Ԥ��30min~");	
    //return;
	$.messager.confirm("��ʾ", "��ȷ��Ҫ������Щ����", function (res) {	// ��ʾ�Ƿ���
		if (res) {
			
			//alert(dicID+"@@"+userInfo+"@@"+rule);
			//��������
			runClassMethod("web.DHCCKBDrugDetail","SaveSingleRules",{"dicID":dicID,"newDicStr":newDicStr,"LgUserId":LgUserID,"userInfo":userInfo,"rulestr":rule,"loginInfo":loginInfo},function(jsonString){
				reloadTree();
				if (jsonString == 0){
					$HUI.dialog('#CopyRuleWin').close();
					$.messager.alert('��ʾ','���Ƴɹ�','info');
				}else{
					$HUI.dialog('#CopyRuleWin').close();
					$.messager.alert('��ʾ','����ʧ��,ʧ�ܴ���:'+jsonString,'warning');
				}
				//QueryDicList();
			});
			//alert("Yes!");
		}
	});		
}

///��Ŀ��Ȩ
function GrantAuthItem(){
	var sucfalg=$("#otherdiclog")[0].contentWindow.SaveManyDatas();	// ��ҳ����־
	//$.messager.popover({msg: '��Ȩ�ɹ���',type:'success',timeout: 1000});
	$HUI.dialog('#win').close();
}
