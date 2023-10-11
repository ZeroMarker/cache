/**
	zhouxin
	2019-06-20
	����ά������
*/
var LastPaNodeId="";		//�ϼ���id
var drugruleID="",drugID="",num=0;  // xww 2021-08-06 ��ȡҩƷ�͹���id
var isrule="",isconfirm="";  // isrule-�ṹ��  isconfirm-��ʵ
var	hospID = "";  //ld  2022-9-5 ���ҽԺ��ѯ
var	attr="",attrVal ="";  //ld  2022-9-6 ������Բ�ѯ
$(function(){ 
	InitParam(); //xww 2021-08-06 ��ȡ���ֵ����ݹ������ý��洫�����Ĳ���
	initCheckbox(); // 2022-05-24 cy ע��checkbox�ĵ����¼�
	initTree();
	//initTable();
	initLookUp();
	//initConstant();
	initButton();
	initSelectTabs();
	initCommbobox();				// ld  2022-9-5 ��ʼ��combobox
})
// 2022-05-24 cy ע��checkbox�ĵ����¼�
function initCheckbox(){
	if ($('input[name="ruleFlag"]:checked').length){
		isrule=$("input[name='ruleFlag']:checked").val();
	}
	if ($('input[name="drugConfirmFlag"]:checked').length){
		isconfirm=$("input[name='drugConfirmFlag']:checked").val();
	}
	$HUI.radio("[name='ruleFlag']",{
        onCheckChange:function(e,value){
           if(value){
           	isrule=this.value;
           }else{
	          isrule=""; 
	       }
        }
    });
    $HUI.radio("[name='drugConfirmFlag']",{
        onCheckChange:function(e,value){
           if(value){
           		isconfirm=this.value;
           }else{
	       		isconfirm=""; 
	       }
        }
    });
}


//xww 2021-08-06
function InitParam(){
	drugruleID = getParam("ruleID");
	drugID = getParam("drugID");
}


function initLookUp(){
   $("#dicLookUp").lookup({
            width:120,
            panelWidth:500,
            panelHeight:410,
            url:LINK_CSP+'?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr=KnowType&extraAttrValue=DictionFlag&params=',
            mode:'remote',
            idField:'ID',
            textField:'CDDesc',
            fitColumns:true,
            columns:[[
            	{field:'ID',title:'ID',hidden:true},
            	{field:'CDCode',title:'����',width:200},    
                {field:'CDDesc',title:'����',width:200}  
            ]],
            pagination:true,
            onSelect:function(index,rowData){
                $('#dicLookUp').lookup('setText',rowData.CDDesc);
                $('#dicTable').datagrid('load', {id: rowData.ID});
                DrugData=rowData.ID
            }
       });
       
      //Ŀ¼
		$('#catDesc').combobox({
			url:$URL+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=QueryCatDic',
			valueField: 'value',
			textField: 'text',
			blurValidValue:true,
			editable:false
		})
}

function initTree(){
	$('#commonRuleTree').tree({
    	/* url:LINK_CSP+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=ListCommonRuleIndexTree&LoginInfo='+LoginInfo, */
    	url:LINK_CSP+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetSortTreeJsonData&LoginInfo='+LoginInfo,
    	lines:true,
		animate:true,
		onContextMenu: function(e, node){
			var defflag=node.defflag
			if ((defflag==1)||(typeof(defflag)=="undefined")){
				e.preventDefault();
				$('#commonRuleTree').tree('select', node.target);
				// ��ʾ��ݲ˵�
				$('#commonRuleMenu').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
			}
			
		},
		onClick:function(node, checked){
			var defflag=node.defflag
			if ((defflag==1)||(typeof(defflag)=="undefined")){
			removeKeyWord();
			onClickTreeNode(node)
				}
			if (defflag==0){
				$('#ruleFrame').attr('src', "");
				}
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
			//return img+desc;
		},
        onLoadSuccess:function(node,data){
	      commonAddTreeTitle("commonRuleTree",data)
	      BindTips();
	    }
	});	
	$('#globalRuleTree').tree({
    	url:LINK_CSP+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=ListGlobalRuleIndexTree&LoginInfo='+LoginInfo,
    	lines:true,
		animate:true,
		onContextMenu: function(e, node){
			
			e.preventDefault();
			$('#globalRuleTree').tree('select', node.target);
			// ��ʾ��ݲ˵�
			$('#globalRuleMenu').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
		 onClick:function(node, checked){
			$("#itmId").val(node.id);
			removeKeyWord();
			onClickTreeNode(node)
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
			//return img+desc; 
			
		},
        onLoadSuccess:function(node,data){
	      commonAddTreeTitle("globalRuleTree",data)
	      BindTips();
	    }
	});	
	$('#modelTree').combotree({
    	url:LINK_CSP+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=ListModelTree'+"&drugType="+InitDrugType(),
    	lines:true,
		animate:true,
		onSelect: function(rec){
			var parent=rec.id;
			runClassMethod("web.DHCCKBRuleIndexEdit","ListModelDataGrid",{"parent":parent},function(data){
				var json= eval('(' + data + ')');
				//json.push({"field":"op","title":"����",formatter:FormatterOP})
				$('#modelTable').datagrid({
					toolbar:"#modelToolbar",
					url:LINK_CSP+"?ClassName=web.DHCCKBRuleIndexEdit&MethodName=ListModelDataNew&parent="+parent+"&drugID="+drugID+"&isrule="+isrule+"&isconfirm="+isconfirm+"&parStr=",  //xww 2021-08-06 �¼�drugID ,
					columns:[json],
					headerCls:'panel-header-gray',
					iconCls:'icon-paper', 
					border:false,
					fit:true,
					fitColumns:true,
					singleSelect:true, 
					pagination:true,
					pageSize:30,
					pageList:[30,60,90],
					displayMsg: '��{total}��¼',
					onClickRow: function (rowIndex, rowData) {		//˫��ѡ���б༭ //hxy 2022-07-06 ˫���ĵ��� onDblClickRow
          			 	/* CommonRowClick(rowIndex,rowData,"#modelTable");
           				dataGridBindEnterEvent(rowIndex); */
           				dataModelClick(rowData);
        			},
	        		onLoadSuccess: function (rowData) {   //xww 2021-08-06 Ĭ�ϼ��ش�������ҩƷ����
		    			if(drugID!=""){
		    				dataModelLoad(rowData.rows[0]);
		    				$('#modelTable').datagrid('selectRow',0); //Ĭ��ѡ�е�һ��
		    			}
		    			TbBindTips();
					}
				});
			},"text","false");
	    },
	    onLoadSuccess: function (node, data) {
		    $('#modelTree').combotree('setValue',data[0].id);
		}
	});	
}
// ��������30��,��������ʾ
function fontNumber (data) {
  var length = data.length;
  if (length > 30) {
    var str ="" ;
    str = data.substring(0, 30) + '......';
    return str ;
  } else {
    return data;
  }
}
/// ���ڵ�div  title��ֵ ��������ȡֵ ��
function commonAddTreeTitle(domId, nodeData) {
	if (nodeData != null && nodeData != "") {
		for (var index = 0; index < nodeData.length; index++) {
			var operNode = $('#' + domId).tree("find", nodeData[index].id + "");
			$(operNode.target).attr("title",nodeData[index].tiptext);
			commonAddTreeTitle(domId, nodeData[index].children);
		}
	}
}
///������ʾ
function BindTips()
{
	/* $(".tree-title").tooltip({
		position:'right',
		content:'<span style="color:#fff" class="_tooltip"></span>',
		onShow:function(){
			tree_title=this;
			//alert($(this).parent().id)
			$("._tooltip").text(tree_title.innerText);
		}
	}) */
	// ȥ�� title ����ʾ��
	$(".tree-title").tooltip({
		position:'none',
		onShow:function(){
			$(this).tooltip('tip').css({
			backgroundColor:'rgba(0,0,0,0)'
			});
		}
	})
	var html='<div id="tip" style="max-width:500px;border-radius:3px;display:none;border:1px solid #000;padding:10px;position:absolute;background-color:#000;color:#fff;"></div>'
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
					opacity: 0.6
				}).text(title);    // .text()  this.innerText
			}
	})
}
function initButton(){
	
	
	/// ����.������ѯ
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
	    }	   
	});
	
	///ģ������ѯ
	$('#queryrules').searchbox({
	    searcher:function(value,name){
	   		ReloadModelGrid(value);
	    }	   
	});
	
	///����
	$("#reset").bind('click',function(){
		$HUI.searchbox("#queryrules").setValue("");
		$HUI.combobox("#hospId").setValue("");
		$HUI.combobox("#LookUp").setValue("");
		$HUI.combobox("#QueCond").setValue("");
		$('#modelTree').combotree("reload");	
		ReloadModelGrid("");
	
	})
	///��ѯ
	$("#search").bind('click',function(){
		var rules=$HUI.searchbox("#queryrules").getValue();	
		ReloadModelGrid(rules);
	})
}

function initSelectTabs(){
	$('#mainPanel').layout('hidden','center'); 
	$('#mainPanel').layout('panel', 'west').panel("resize", {
		width:document.body.clientWidth-10
	}); 
	$HUI.tabs("#ruleTabs",{
		onSelect:function(title){
			/// �ֵ�����Ϊ���ڹ���
			if ((title=="�������")||(title=="ȫ�ֹ���")){	
				$('#mainPanel').layout('panel', 'west').panel("resize", {
					width:550
				});	
				$('#ruleTabs').tabs({
					//width:document.body.clientWidth-560
				});	
				var eastwid = $("#mainPanel").layout("panel", "center")[0].clientWidth;
				if(eastwid == 0){
					$('#mainPanel').layout('show', 'center');
				}
			}else{
				$('#mainPanel').layout('panel', 'west').panel("resize", {
					width:document.body.clientWidth-10
				});
				$('#ruleTabs').tabs({
					width:document.body.clientWidth-10
				});				
				$('#mainPanel').layout('hidden','center');  
	
			}
		}
	}); 
}
/// ��ʼ��combobox
function initCommbobox(){
	
	// Ժ��
  	var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
  	$HUI.combobox("#hospId",{
	    url:uniturl,
	    valueField:'value',
					textField:'text',
					panelHeight:"150",
					mode:'remote',
					onSelect:function(option){
						hospID = option.value;
					}
	})
	///����
	$("#LookUp").combobox({
		url:$URL+'?ClassName=web.DHCCKKBIndex&MethodName=QueryDrugAttr',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option) {
			$("#QueCond").combobox('setValue',"");
			var unitUrl = $URL+"?ClassName=web.DHCCKKBIndex&MethodName=QueryAttrData&Parref="+option.value
			$("#QueCond").combobox('reload',unitUrl);
			attr = option.value;
		}
		
	})
	///����ֵ
	$("#QueCond").combobox({
		url:'',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option){
			attrVal = option.value;
		}
	})
	
}
function getParStr(){
		
		// ��������ֵ������ ���룩
		var attr=$("#LookUp").combobox('getValue');
		if(attr!=undefined){
			attr=attr;
		}else{
			attr="";
		}
		// �����ж�ֵ ����������ݣ�
		var attrVal=$("#QueCond").combobox('getValue');
		if(attrVal!=undefined){
			attrVal=attrVal;
		}else{
			attrVal="";
		}
		// ��_$c(1)_ֵ_$c(1)_�ж�����_$c(1)_�߼���ϵ
		var par=attr+"$"+attrVal+"$"+"";
		return par;
}
function QueryDicList(){

	var params = $HUI.searchbox("#queryCode").getValue();
	$('#dicTable').datagrid('load',{
		id:DrugData,
		parDesc:params	
	}); 
}


function addModelKeyWord(){
	if(!endEditing("#modelTable")){
		$.messager.alert("��ʾ","��༭��������!");
		return;
	}
	var Selected=$('#modelTable').datagrid('getSelected')
	if(Selected==null){
		$.messager.alert("��ʾ","��ѡ���¼");
		return;
	}
	
	$('#ruleFrame').attr('src', "dhcckb.rule.edit.csp?ruleId=0"+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():""));	
	
}
function initModelDataGrid(id){
	var index=$('#modelTable').datagrid('getRowIndex',Selected)
	var opts = $('#modelTable').datagrid('getColumnFields');
	//console.table($('#modelTable').datagrid('getRows'));
	removeKeyWord();
	for(var i=0;i<opts.length;i++){
		var colOpt=$('#modelTable').datagrid('getColumnOption',opts[i])
		if(colOpt.hidden===false){
			var desc=Selected[colOpt.field]
			var value=$('#modelTable').datagrid('getRows')[index][colOpt.field+"Id"]
			if(value==""){
				continue;	
			}
			//console.log(value+"^"+desc)
			addKeyWord(value,desc,"");
		}	
	}
		runClassMethod(
			"web.DHCCKBRuleSave",
			"RemoveRule",
			{"ruleId":node.ruleId},
			function(jsonString){
				reloadTree();
		});	
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
		 var url="dhcckb.rule.editor0.csp?ruleId="+ruleId+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"");
		 $('#ruleFrame').attr('src', url);	
}

function CreateRule(){
	var node = $("#ruleTree").tree('getSelected');
	if(node.ruleId!=undefined){
		$.messager.alert("��ʾ","�����ڹ���������");
		return;
	}	
	var ruleId=0,relation=0,dicCode=0;
	dicCode=node.id;
	relation=node.relation;
	addKeyWord(node.id,node.text,"");
	var url="dhcckb.rule.editor0.csp?ruleId="+ruleId+"&relation="+ dicCode+"&dicCode="+relation+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"");
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
		$.messager.alert("��ʾ","��ѡ�й���!");   
	}

}
///�ƶ����� sufan 20200212
function MoveRule(){
	$("#ruleMoveWin").show();
	$HUI.combobox("#catDesc").setValue("");	
	var option = {
		modal:true,
		collapsible : false,
		minimizable : false,
		maximizable : false,
		border:true,
		closed:"true"
	};
	var title = "�ƶ�����";		
	new WindowUX(title, 'ruleMoveWin', '400', '150', option).Init();
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
	
	var linkurl = "dhcckb.diclog.csp"+"?HideFlag="+hideFlag+"&DicName="+tableName+"&dataid="+dataId+"&SetFlag="+setFlag+"&ClientIP="+ClientIPAdd+"&TableName="+tableName+"&CloseFlag=1"+"&Operator="+LgUserID;
	linkurl += ("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"";
	
	$('body').append('<div id="win"></div>');
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-write-order',
        title:'��Ȩ',
        modal:true,
        width:700,
        height:500,
        content:"<iframe id='otherdiclog' scrolling='auto' frameborder='0' src='"+linkurl+"' "+"style='width:100%; height:100%; display:block;'></iframe>",
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
///���ƹ��� Sunhuiyong 20201116
function CopyRuleOld()
{
	var dicID=$('#modelTable').datagrid('getSelected').ID;
	var userInfo=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
	var node = $("#ruleTree").tree('getSelected');
	var rule = node.id;
	$.messager.confirm("��ʾ", "��ȷ��Ҫ���ƴ�������", function (res) {	// ��ʾ�Ƿ���
		if (res) {
			
			//alert(dicID+"@@"+userInfo+"@@"+rule);
			//��������
			runClassMethod("web.DHCCKBDrugDetail","SaveSingleRule",{"dicID":dicID,"newDicID":dicID,"LgUserId":LgUserID,"userInfo":userInfo,"rule":rule},function(jsonString){
				reloadTree();
				if (jsonString == 0){
					$.messager.alert('��ʾ','���Ƴɹ�','info');
				}else{
					$.messager.alert('��ʾ','����ʧ��,ʧ�ܴ���:'+jsonString,'warning');
				}
				//QueryDicList();
			});
			//alert("Yes!");
		}
	});	
}


function CopyRule()
{
   var dicID=$('#modelTable').datagrid('getSelected').ID;
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


	var mode= $HUI.combotree('#modelTree').getValue();
	var url = LINK_CSP+"?ClassName=web.DHCCKBRuleCopy&MethodName=GetDicComboboxList&extraAttr="+"KnowType" +"&extraAttrValue="+"DrugData"+"&mode="+mode;
	new ListCombobox("newDicDrug",url,'',option).init(); 
}
//���ƶ��ѡ�й��� sunhuiyong
function SaveCopyRuleData()
{
	var dicID=$('#modelTable').datagrid('getSelected').ID;
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
function saveMoveRule()
{
	var node = $("#ruleTree").tree('getSelected');
	var ParNode = $('#ruleTree').tree('getParent',node.target);
	var CatId = $HUI.combobox("#catDesc").getValue();
	runClassMethod("web.DHCCKBRuleIndexEdit","DragRule",{"RuleId":node.id,"LastCatId":ParNode.id,"NewCatId":CatId},
            	function(data){
	            	if(data==0){
		            	$.messager.popover({msg: '�ƶ��ɹ���',type:'success',timeout: 1000});
		            	//$("#ruleTree").tree('reload');
		            	$("#ruleTree").tree('remove',node.target);
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
//sunhuiyong 2021-2-23 �����ƶ�����
function saveMoveRules()
{
	var node = $("#ruleTree").tree('getSelected');
	var ParNode = $('#ruleTree').tree('getParent',node.target);
	var CatId = $HUI.combobox("#catDesc").getValue();
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
	runClassMethod("web.DHCCKBRuleIndexEdit","DragRules",{"RuleId":rule,"LastCatId":ParNode.id,"NewCatId":CatId},
            	function(data){
	            	if(data==0){
		            	$.messager.popover({msg: '�ƶ��ɹ���',type:'success',timeout: 1000});
		            	//$("#ruleTree").tree('reload');
		            	$("#ruleTree").tree('remove',node.target);
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




function AddRule(id){
	
	var node = $("#"+id).tree('getSelected');
	if(node.ruleId!=undefined){
		$.messager.alert("��ʾ","�����ڹ���������");
		return;
	}	
	var dicCode=node.id;
	
	var url="dhcckb.rule.editor0.csp?ruleId=0&relation="+ dicCode+"&dicCode="+AddRuleFlag+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"");
	$('#ruleFrame').attr('src', url);	
}

function DeleteComRule(id){
	var node =  $("#"+id).tree('getSelected');
	if(node.ruleId!=undefined){
			$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����", function (res) {
				/// ��ʾ�Ƿ�ɾ��
				if (res) {
					runClassMethod("web.DHCCKBRuleSave","RemoveRule",{"ruleId":node.ruleId},function(jsonString){
						reloadTree();
					});
				}
			})	
    }else{
		$.messager.alert("��ʾ","��ѡ�й���!");   
	}
}


///�����б�
function initTable(){

	$('#dicTable').datagrid({
		toolbar:"#toolbar",
		url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+DrugData,
		columns:[[ 
			{field:'ID',hidden:true},
			{field:'CDCode',title:'����',align:'center',hidden:true},
			{field:'CDDesc',title:'����',width:350,align:'center',formatter: function(value,row,index){
				if (row.RuleFlag == 1){
					return "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"+value;
				} else {
					return value;
				}
			}},
			{field:'op',title:'����',width:50,formatter:FormatterAdd}			
		 ]],
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
		onDblClickRow: function (rowIndex, rowData) {
			dataGridDBClick(rowData)
        },
        onLoadSuccess:function(data){
	        if(data.rows.length>0){
				//dataGridDBClick(data.rows[0])
		    }
	    },
        displayMsg: '��{total}��¼'
	});
}

function dataGridDBClick(rowData){
	
	    $("#ruleTree").tree("options").url=LINK_CSP+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetDrugLibraryTree&dic='+rowData.ID+'&userInfo='+LoginInfo;
		$('#ruleTree').tree('reload');
		removeKeyWord();
		addKeyWord(rowData.ID,rowData.CDDesc,"")
		getRuleIframe(0)
}
///Ŀ¼¼��˫���¼� sufan 20200214
function dataModelClick(rowData){
		var url="dhcckb.rule.indexdir.csp?ModelDic="+rowData.ID+"&LoginInfo="+LoginInfo+"&ruleID="+drugruleID+"&drugID="+drugID;
		url += ("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"";
		var content = '<iframe src="' + url + '" width="100%" height="99%" frameborder="0" scrolling="yes"></iframe>';
		$('#dirDia').dialog({
				content: content,
				width:window.innerWidth-100, //1400,
                //width:window.screen.availWidth-100, //1400,
                height:window.screen.availHeight-140, //800,
                maximized: false,//Ĭ�����
                modal: true
		});
		$('#dirDia').dialog('open');
		
	    $("#ruleTree").tree("options").url=$URL+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetDrugLibraryTree&dic='+rowData.ID+'&userInfo='+LoginInfo;
		$('#ruleTree').tree('reload');
		removeKeyWord();
		getRuleIframe(0)
		var selItem=$("#modelTable").datagrid('getSelected');
		var opts = $('#modelTable').datagrid('getColumnFields');
		var value="";
		for(var i=0;i<opts.length;i++){
			var colOpt=$('#modelTable').datagrid('getColumnOption',opts[i])
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
function getRuleIframe(ruleId){
	$('#ruleFrame').attr('src', "dhcckb.rule.editor0.csp?ruleId="+ruleId+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"")); 
}

function FormatterAdd(value,rowData){
	return "<span style='cursor: pointer' class='icon icon-add' onClick='addKeyWord("+rowData.ID+",\""+rowData.CDDesc+"\","+""+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>"
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
///ɾ���ؼ���
function removeKeyWordByObj(obj){
	
	var title=$(obj).attr("title")
	$.messager.confirm("������ʾ", "ȷ��Ҫɾ��<font color='red' >"+title+"</font>��", function (data) {  
            if (data) {  
               $(obj).parent().remove();
            } 
    }); 	
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
///ɾ��Ŀ¼
function clearKeyWord(){
	$.messager.confirm("������ʾ", "ȷ��Ҫ���Ŀ¼��", function (data) {  
            if (data) {  
               removeKeyWord();
            } 
    }); 
}
function removeKeyWord(){
	$("#selectKeyWords").html("");
}
function lifeCycle(t){
	
	if(t==0){
		$.messager.alert("��ʾ","��ѡ�����");
		return;	
	}
	
	var url="dhcckb.rule.life.csp?ruleId="+t;
	url += ("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"";
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

function initConstant(){
	
	//���ݼ�
	/***/
    $.getJSON("web.DHCCKBRuleConstants.cls", function(json){
  		window._uruleEditorConstantLibraries = json;

	});
}

function addModelRow(){
	
	commonAddRow({'datagrid':'#modelTable',value:{}})
	dataGridBindEnterEvent(0);
}

function dataGridBindEnterEvent(index){
	
	editRow=index;
	var editors = $('#modelTable').datagrid('getEditors',index);

	for(var i=0;i<editors.length;i++){
		var workEditor = editors[i];
		
		editors[i].target.attr("field",editors[i].field);
		
		editors[i].target.mousedown(function(e){
				var field=$(this).attr("field")
				var ed=$("#modelTable").datagrid('getEditor',{index:index, field:field});		
				var input = $(ed.target).val();
				divComponent({
							  tarobj:$(ed.target),
							  filed:field,
							  input:input,
							  htmlType:'datagrid',
							  height:'260',
							  url:LINK_CSP+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id='+field+"&parDesc="+encodeURIComponent(input),
							  columns:[[
							  	{field:'ID',hidden:true},
							  	{field:'CDDesc',title:'����',width:60}
							  ]] 
							},function(rowData){
								$(ed.target).val(rowData.CDDesc);
								var IdEd=$("#modelTable").datagrid('getEditor',{index:index,field:field+"Id"});
								$(IdEd.target).val(rowData.ID);
								$("#win").remove();
							})
			
		});
		
		
	}
}
/// ����/�޸�ȫ�ֹ���
function editGlobalItm(type){

	if (type == "E"){
		var node =  $("#globalRuleTree").tree('getSelected');	
		if (node == null){
			$.messager.alert("��ʾ","��ѡ��һ����Ŀ�����޸�!");
			return;
		}
		if (node.ruleId != undefined){
			return;
		}
		$("#itmId").val(node.id);
		$("#itmCode").val(node.code);
		$("#itmDesc").val(node.text);
	}else{
		$("#itmId").val("");
		$("#itmCode").val("");
		$("#itmDesc").val("");
	}
	newCreateWin();	
}

/// Window ����
function newCreateWin(){	
	$("#globalWin").show();	
	var option = {
		modal:true,
		collapsible:false,
		minimizable: false,
		maximizable: false,
		iconCls: 'icon-w-save',
		border:true,
		closed:"true"
	};
	var title = "ȫ�ֹ����ֵ�";		
	new WindowUX(title, 'globalWin', '400', '165', option).Init();
}

/// ɾ��ȫ�ֹ���
function delGlobalItm(){
	
	var node =  $("#globalRuleTree").tree('getSelected');	
	if (node == null){
		$.messager.alert("��ʾ","��ѡ��һ����Ŀɾ��!","info");
		return;
	}
	if (node.ruleId != undefined){
		return;
	}
	if (node.children.length != 0){
		$.messager.alert("��ʾ","ѡ�����Ŀ���й���,����ֱ��ɾ����Ŀ!","info");
		return;
	}
	var id=node.id;
	if (id != "") {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":id},function(jsonString){
					$('#globalRuleTree').tree('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
	
}

/// �رմ���
function closeGlobalWin(){
	$("#globalWin").window("close");
}

/// ����ȫ�ֹ����ֵ�
function saveGlobalItm(){

	var id=$("#itmId").val();
	var code=$("#itmCode").val();
	var desc=$("#itmDesc").val();
	
	if (code == ""){
		$.messager.alert("��ʾ","���벻��Ϊ��!");
		return;
	}
	if (desc == ""){
		$.messager.alert("��ʾ","��������Ϊ��!");
		return;
	}
	
	var params=id +"^"+ code +"^"+ desc +"^"+globalparref;
	//��������
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":""},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			return;	
		}else{
			$.messager.alert('��ʾ','����ɹ���','info');
			closeGlobalWin();
			$("#globalRuleTree").tree('reload');
			return;
		}
	});
}
///��ѯģ�����

function ReloadModelGrid(Input)
{
	/* if(hospID ==""){
		$.messager.alert("��ʾ","��ѡ��һ��Ժ��!","info");
		return;
	} */
	var parent = $HUI.combotree('#modelTree').getValue();
	if ($('input[name="ruleFlag"]:checked').length){
		isrule=$("input[name='ruleFlag']:checked").val();
	}
	if ($('input[name="drugConfirmFlag"]:checked').length){
		isconfirm=$("input[name='drugConfirmFlag']:checked").val();
	}
	var parStr=getParStr();
	$("#modelTable").datagrid('reload',{"parent":parent,"Input":Input,"isrule":isrule,"isconfirm":isconfirm,"hospID":hospID,"parStr":parStr });
}
///����ģ�����
function FormatterOP(value,rowData,index)
{
	return "<span style='cursor: pointer' class='icon icon-add' onClick='addRulueKeyWord("+rowData+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>"
}
function addRulueKeyWord(rowData)
{
	dataModelClick(rowData);
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
		
		var selecItm=$("#modelTable").datagrid('getSelected');
		var dicId=selecItm.ID;
		$("#ruleTree").tree("options").url=$URL+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetDrugLibraryTree&dic='+dicId+'&userInfo='+LoginInfo;
		$('#ruleTree').tree('reload');	
	
	});
}

/// ҩƷ����
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
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


///Ŀ¼¼��˫���¼� xww 20210806 Ĭ��ѡ�д���Ĺ���
function dataModelLoad(rowData){
		
	    $("#ruleTree").tree("options").url=$URL+'?ClassName=web.DHCCKBRuleIndexEdit&MethodName=GetDrugLibraryTree&dic='+rowData.ID+'&userInfo='+LoginInfo;
		$('#ruleTree').tree('reload');
		removeKeyWord();
		getRuleIframe(drugruleID)
		var selItem=$("#modelTable").datagrid('getRows')[0];
		var opts = $('#modelTable').datagrid('getColumnFields');
		var value="";
		for(var i=0;i<opts.length;i++){
			var colOpt=$('#modelTable').datagrid('getColumnOption',opts[i])
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

function resize(){
	
	$('.mainpanel').css("width","700px");
	$('.treeitem').css("left","720px");
	$('.treeitem').css("right","0");
	$('.griditem').css("width","0");
	//$.parser.parse('.mainpanel');
}

/// ����ʾ��
function TbBindTips(){
	var html='<div id="TbTip" style="word-break:break-all;border-radius:3px; display:none; border:1px solid #000; padding:10px;position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	
	/// ����뿪
	$('td[field="81224"]').on({
		'mouseleave':function(){
			$("#TbTip").css({display : 'none'});
		}
	})
	/// ����ƶ�
	$('td[field="81224"]').on({
		'mousemove':function(){
			var tleft=(event.clientX + 10);
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip ��ʾ��λ�ú������趨
			$("#TbTip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 0.6
			}).text($(this).text());
		}
	})
}
