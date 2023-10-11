//===========================================================================================
// Author��      Sunhuiyong
// Date:		 2020-03-20
// Description:	 �°��ٴ�֪ʶ��-ͣ������
//===========================================================================================
var editRow = 0,editsubRow=0;
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "DictionFlag" 	// �ֵ���(��������ֵ)
var parref="";
var IP=window.parent.ClientIPAddress;
var ChkValue=""
var flagValue = "1"
/// ҳ���ʼ������
function initPageDefault(){
	
	InitButton();		// ��ť��Ӧ�¼���ʼ��
	InitCombobox();		// ��ʼ��combobox
	InitDataList();		// ҳ��DataGrid��ʼ������
	InitTree();     	// ��ʼ������
	InitSubDataList()	// �ֵ��
}

/// ҳ��DataGrid��ʼ����ͨ����
function InitDataList(){
						
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ����columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'����',width:200,align:'left',editor:texteditor},
			{field:'CDDesc',title:'����',width:300,align:'left',editor:texteditor},
			{field:'Parref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'ParrefDesc',title:'���ڵ�',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'����',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"֪ʶ����",width:200,align:'left',hidden:true},
			{field:'DataType',title:"��������",width:200,align:'left',hidden:true},
			{field:'IsStop',title:"״̬",width:200,align:'left',formatter:function(value,row,index){
				if(value==1)
				{
					return "����"
				}else if(value==0)
				{
					return "ͣ��"	
				}
				},hidden:false}
			
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){ 	     
		   parref = rowData.ID;
		   var flagStop = $HUI.checkbox("#dd1").getValue();
		   //alert(flagStop)
		   if(flagStop==false)
		   {
			flagValue = 1
		   	$("#subdiclist").datagrid("load",{"DataID":parref,"flagValue":flagValue});
		   }else
		   {
			flagValue = 0
			$("#subdiclist").datagrid("load",{"DataID":parref,"flagValue":flagValue}); 
		   }
		}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
          
        },
        onLoadSuccess:function(data){
          $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
          $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({
              });
            }
          });          
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&userID="+LgUserID+"&locID="+LgCtLocID+"&groupID="+LgGroupID+"&hospID="+LgHospID+"&params=";
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}


/// ��ť��Ӧ�¼���ʼ��
function InitButton(){
	
	$("#reset").bind("click",InitPageInfo);	// ����
	$("#reuse").bind("click",ReuseDic);	// ����
	/// ����.������ѯ
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
	    }	   
	});	
	
	$('#subQueryCode').searchbox({
	    searcher:function(value,name){
	   		SubQueryDicList();
	    }	   
	});
	
	$("#subinsert").bind("click",SubInsertRow);	// ��������
	
	$("#subsave").bind("click",SubSaveRow);		// ����
	
	$("#subdel").bind("click",SubDelRow);	// ɾ��
	
	$("#acdataflag").bind("click",AcDataFlag);	// ��ʵ
	
	$("#setparref").bind("click",ResetParref);	// �����ֵ�ָ��
	
	$("#settreeparref").bind("click",ResettreeParref);	// �����ֵ�ָ��-tree
	
	//$("#subfind").bind("click",SubQueryDicList);	// ��ѯ
	
	$("#resetsub").bind("click",InitSubPageInfo);	// ����
	
	/// tabs ѡ�
	$("#tabs").tabs({
		onSelect:function(title){
			
		   	LoadattrList(title);
		}
	});
	
	///���Լ���
	$('#attrtreecode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			findattrTree(searcode);
		}
	});
	
	///���Լ���
	$('#dictreecode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			finddicTree(searcode);
		}
	});
	
	///ʵ��
	$('#entityCode').searchbox({
	    searcher:function(value,name){
	   		QueryWinDicList();
	    }	   
	});
	
	$("#resetwin").bind("click",InitPageInfoWin);	// ����
	
	$('#myChecktreeDesc').searchbox({
	    searcher:function(value,name){
		    finddgList(value);
	    }	   
	});	
	
	$HUI.radio("[name='FilterCK']",{
        onChecked:function(e,value){
	        ChkValue=this.value;
	       	var seavalue=$HUI.searchbox("#myChecktreeDesc").getValue();
	       	finddgList(seavalue);
        }
     });
}

/// ��ʼ��combobox
function InitCombobox(){	
}

// ��ѯ
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();
	
	$('#diclist').datagrid('load',{
		extraAttr:extraAttr,
		extraAttrValue:extraAttrValue,
		params:params
	}); 
}

// ���� 
function InitPageInfo(){
	
	//$("#code").val("");
	//$("#desc").val("");
	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	

}
// �����ֵ� Sunhuiyong 2020-04-03
function ReuseDic()
{
	var rowsData = $("#diclist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫ���ø��ֵ䣿", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {
				var OperateDate=SetDateTime("date");
				var OperateTime=SetDateTime("time");
				runClassMethod("web.DHCCKBWriteLog","ReUseData",{"StopRowID":rowsData.ID,"DicID":rowsData.ID,"LgUserID":LgUserID,"OperateDate":OperateDate,"OperateTime":OperateTime,"ClientIPAddress":ClientIPAdd},
        	function(data){
            	if(data==1){
	            	$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
	            	$("#subdiclist").datagrid('reload');
	            	return false;
	           	}else{
				        $.messager.popover({msg: '�޸�ʧ�ܣ�',type:'success',timeout: 1000});
	            		return false;
		        }
	 })
			}
		});		
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫ���õ��ֵ䣡','warning');
		 return;
	}			
}
//==================================================ͣ������ά������============================================================//
/// ҳ��DataGrid��ʼ����ͨ����
function InitSubDataList(){
						
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ����columns   
	var columns=[[   	 
			{field:'DataID',title:'DataID',hidden:true},
			{field:'dicID',title:'dicID',hidden:false},
			{field:'DataDesc',title:'����',width:300},
			{field:'Function',title:'����',width:100,align:'left',formatter: function(value,row,index){
				if (value=="stop")
				{
					return "ͣ��";
					
				} else if(value=="confirm")
				{
					return "��ʵ";	
				}else if(value=="enable")
				{
					return "����"	
				}else
				{
					return value;	
				}
			}},
			{field:'DateTime',title:'��������',width:250,align:'left'},
			{field:'TimeTime',title:'����ʱ��',width:250,align:'left'},
			{field:'Scope',title:'������',width:250,align:'left',formatter: function(value,row,index){
				if (value=="U"){
					return "��Ա";
				} else if(value=="G")
				{
					return "��ȫ��";
					
				}else if(value=="L")
				{
					return "����"	
				}else if(value=="D")
				{
					return "ȫԺ"	
				}else if(value=="P")
				{
					return "ְ��"	
				}
			}},
			{field:'ScopeValue',title:'������ֵ',width:250,align:'left'},
			{field:'UserID',title:'�û�',width:250,align:'left',hidden:true},
			{field:'Operating',title:'����',width:200,align:'center',formatter:SetCellOperation} 

		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){
	 		
	 		}, 
		onDblClickRow: function (rowIndex, rowData) {
            
        },
        onLoadSuccess:function(data){
            $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({});
            }
          });          
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBWriteLog&MethodName=GetStopDataValue&DataID="+parref+"&flagValue"+flagValue;
	//var newurl = $URL+"?ClassName=web.DHCCKBWriteLog&MethodName=QueryStopByAuto&DataID="+parref;
	new ListComponent('subdiclist', columns, uniturl, option).Init();
	
}
/// sub��������
function SubInsertRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);		//�����༭������֮ǰ�༭����
	}
	$("#subdiclist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#subdiclist").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	editsubRow=0;
}

/// sub����
function SubSaveRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);
	}

	var rowsData = $("#subdiclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].CDCode=="")||(rowsData[i].CDDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc) +"^"+ parref;
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";

	//��������
	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LgUserID":LgUserID,"LgHospID":LgHospID},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}else if(jsonString == -98){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');
			
		}else if(jsonString == -99){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');

		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		SubQueryDicList(parref);		
		//$('#diclist').datagrid('reload'); //���¼���
	});
}

/// subɾ��    sunhuiyong 2020-02-03 ɾ��������в�����ɾ�� 
function SubDelRow(){
	var rowsData = $("#subdiclist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫͣ����Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDiction","UsedDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						SetFlag="STDATA"        //ͣ�����ݱ��
						DicName="DHC_CKBCommonDiction"
						dataid=rowsData.ID
						Operator=LgUserID
						//$HUI.dialog("#diclog").open();
						var link = "dhcckb.diclog.csp?DicName="+ DicName +"&Operator="+ LgUserID +"&SetFlag="+ SetFlag +"&dataid="+dataid+"&ClientIP="+IP;
						window.open(link,"_blank","height=400, width=650, top=200, left=400,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
					}else if (jsonString == "-1"){
						 $.messager.alert('��ʾ','�������ѱ�����,����ֱ��ͣ�ã�','warning');
					}		
				})
			}
		});		
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫͣ�õ���','warning');
		 return;
	}		

}
function reloadDatagrid(){
	$("#diclist").datagrid("reload");
	$("#subdiclist").datagrid("reload");
}
///��ʵ Sunhuiyong 2020-02-20
function AcDataFlag(){
	var rowsData = $("#subdiclist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
						SetFlag="ACDATA"        //��ʵ���ݱ��
						DicName="DHC_CKBCommonDiction"
						dataid=rowsData.ID
						Operator=LgUserID
						//$HUI.dialog("#diclog").open();
						var link = "dhcckb.diclog.csp?DicName="+ DicName +"&Operator="+ LgUserID +"&SetFlag="+ SetFlag +"&dataid="+dataid;
						window.open(link,"_blank","height=400, width=650, top=200, left=400,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
						}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫ��ʵ����','warning');
		 return;
	}	
		
}
/// sub ��ѯ
function SubQueryDicList(id){
	
	var params = $HUI.searchbox("#subQueryCode").getValue();
	
	$('#subdiclist').datagrid('load',{
		DataID:parref,
		parDesc:params,
		flagValue:flagValue
	}); 
}

// ����
function InitSubPageInfo(){

	$HUI.searchbox('#subQueryCode').setValue("");
	SubQueryDicList();	

}

/// �ֵ������
function InitTree(){
	var url = "" //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref 
	var option = {
		height:$(window).height()-105,   ///��Ҫ���ø߶ȣ���Ȼ����չ��̫��ʱ����ͷ�͹�����ȥ�ˡ�
		multiple: true,
		lines:true,
		checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//�Ƿ�����顣Ĭ��true  �˵����⣬����������
		fitColumns:true,
		animate:true,
        onClick:function(node, checked){
	        var isLeaf = $("#dictree").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
		        							   
	        }else{
		    	//$("#attrtree").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
		    }
	    },
	    onCheck:function(node,checked)
	    {
		    $(this).tree('select', node.target);
		},
	    onContextMenu: function(e, node){
			
			e.preventDefault();
			$(this).tree('select', node.target);
			var node = $("#dictree").tree('getSelected');
			if (node == null){
				$.messager.alert("��ʾ","��ѡ�нڵ������!"); 
				return;
			}
				
			// ��ʾ��ݲ˵�
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
	    onExpand:function(node, checked){
			var childNode = $("#dictree").tree('getChildren',node.target)[0];  /// ��ǰ�ڵ���ӽڵ�
			
	        var isLeaf = $("#dictree").tree('isLeaf',childNode.target);        /// �Ƿ���Ҷ�ӽڵ�
	        if (isLeaf){
	        }
		}
	};
	new CusTreeUX("dictree", url, option).Init();
	//$('#CheckPart').tree('options').url = uniturl;
	//$('#CheckPart').tree('reload');		
}
/// ��ѯ����
function SearchData(){
	var desc=$.trim($("#FindTreeText").val());
	$("#dictree").tree("search", desc)
	//$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //ȡ�����Ľڵ�ѡ��
}
/// ���÷���
function ClearData(){
	
	$("#FindTreeText").val("");
	$('#dictree').tree('reload')
	//$('#dictree').tree('uncheckAll');
	$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //ȡ�����Ľڵ�ѡ��
}
//�������ӽڵ㰴ť
function AddDataTree() {
	RefreshData();
	var options={};
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref
	$('#parref').combotree(options);
	$('#parref').combotree('reload')
	
	$("#myWin").show();
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-addlittle',
		resizable:true,
		title:'���',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'����',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				SaveDicTree(1)
			}
		},{
			text:'�������',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				TAddDicTree(2)
			}
		},{
			text:'�ر�',
			handler:function(){
				myWin.close();
			}
		}]
	});	
	
	var record =$("#dictree").tree('getSelected');
	
	if (record){
		//$("#treeID").val(record.id);
		//var parentNode=$("#dictree").tree("getParent",record.target)	
		//if (parentNode){	
		//alert(record.id)	
			$('#parref').combotree('setValue', $g(record.id));
		//}
	}
}
/// �������
function RefreshData(){
	$("#treeID").hide();
	$("#treeID").val("");
	$("#treeCode").val("");
	$("#treeDesc").val("");
	$('#parref').combotree('setValue','');
};


///����
function SetCellOperation(value, rowData, rowIndex){

	var btn = "<img class='mytooltip' title='����' onclick=\"ReUse('"+rowData.StopRowID+"','"+rowData.dicID+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn; 
}
function ReUse(StopRowID,DicID){
		$.messager.confirm('ȷ�϶Ի���','ȷ�����ø�������', function(r){
		if (r){
				var OperateDate=SetDateTime("date");
				var OperateTime=SetDateTime("time");
				var SetFlag="enable"    //�������ݱ��
				var DicName="DHC_CKBCommonDiction"
				//runClassMethod("web.DHCCKBWriteLog","ReUseData",{"StopRowID":StopRowID,"DicID":DicID,"LgUserID":LgUserID,"OperateDate":OperateDate,"OperateTime":OperateTime,"ClientIPAddress":ClientIPAdd},   Sunhuiyong 2020-04-08 �޸�Ϊ��������-����
      runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":DicID,"Function":SetFlag,"Operator":LgUserID,"OperateDate":OperateDate,"OperateTime":OperateTime,"Scope":"","ScopeValue":"","ClientIPAddress":ClientIPAdd,"Type":"log"},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
	            	$("#subdiclist").datagrid('reload');
	            	return false;
	           	}else{
				        $.messager.popover({msg: '�޸�ʧ�ܣ�',type:'success',timeout: 1000});
	            		return false;
		        }
	 })
		}
	});

	}
function SetDateTime(flag)
{
	var result=""
	runClassMethod("web.DHCCKBWriteLog","GetDateTime",{"flag":flag},function(val){	
	  result = val
	},"text",false)
	return result;
}

/// ��ʼ��tabs�е����ݱ��
function SetTabsInit(){

	var AddextraAttrValue = "AttrFlag" 	// knowledge-����
	// ����
	var myAttrTree = $HUI.tree("#attrtree",{
		url:"", //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue,
   		lines:true,  //���ڵ�֮����ʾ����
		autoSizeColumn:false,
		//checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  //�Ƿ�����顣Ĭ��true  �˵����⣬����������
		animate:false     	//�Ƿ���չ���۵��Ķ���Ч��		
	});
	
	var AddextraAttrValue = "DictionFlag" 	// knowledge-����
	// ����
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+AddextraAttrValue;
	var DicTree = $HUI.tree("#dicextratree",{
		url:uniturl, 
   		lines:true,  //���ڵ�֮����ʾ����
		autoSizeColumn:false,
		//checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//�Ƿ�����顣Ĭ��true  �˵����⣬����������
		animate:false,    			//�Ƿ���չ���۵��Ķ���Ч��
		onClick:function(node, checked){
	    	
	    },
	    onLoadSuccess: function(node, data){
			if (node != null){
					$('#dicextratree').tree('expand', node.target);
			}
		}
			
	}); 
	
	// �ֵ�
	var diccolumns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'����',width:200,align:'left'},
			{field:'CDDesc',title:'����',width:300,align:'left'}			
		 ]]		 
	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90]	
		  
	}
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";
	new ListComponent('dicgrid', diccolumns, uniturl, option).Init();
  
    // ʵ��
	var entitycolumns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'����',width:200,align:'left'},
			{field:'CDDesc',title:'����',width:300,align:'left'}			
		 ]]
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";
	new ListComponent('entitygrid', entitycolumns, uniturl, option).Init();

}
/// ����
function SaveFunLib(){

	var currTab = $('#tabOther').tabs('getSelected');
	var currTabTitle = currTab.panel('options').title;
	var selectID=""
	var selectDesc=""
	
	
	if (currTabTitle.indexOf("����")!=-1){					// ѡ������
		var attrrow = $('#attrtree').tree('getSelected');	// ��ȡѡ�е���  
		selectID = $g(attrrow)==""?"":attrrow.id;
		selectDesc =  $g(attrrow)==""?"":attrrow.code;
		
	}else if(currTabTitle.indexOf("�ֵ�") != -1){				// ѡ���ֵ�
	
		var dicrow =$('#dicextratree').tree('getSelected');	// ��ȡѡ�е���
		selectID = $g(dicrow)==""?"":dicrow.id;
		selectDesc =  $g(dicrow)==""?"":dicrow.code;
		
	}else if(currTabTitle.indexOf("ʵ��") != -1){				// ѡ��ʵ��
	
		var entityrow =$('#entitygrid').datagrid('getSelected'); // ��ȡѡ�е���  
		selectID = $g(entityrow)==""?"":entityrow.ID;
		selectDesc =  $g(entityrow)==""?"":entityrow.CDDesc;
	}

	if ($g(selectID) == ""){	
		 $.messager.alert('��ʾ','��ѡ��һ�����Ի��ֵ��ʵ�壡','info');
		 return;	
	} 
	
	/// �������Խ��渳ֵ
	$('#addattrlist').datagrid('beginEdit', editaddRow);	
	//var attrDescObj=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
	//$(attrDescObj.target).val(selectDesc);
	var attrDrObj=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'DLAAttrDr'});
	$(attrDrObj.target).val(selectID);
	$('#addattrlist').datagrid('endEdit', editaddRow);
	saveRowAddAttr();

	//$HUI.dialog("#myWin").close();
}
///����
function saveRowAddAttr()
{
	// ʹ�ô˷�������ʱ����Ҫdatagrid�������ͱ��ֶ�������ͬ���޸�ʱIDĬ�Ϲ̶�
	comSaveByDataGrid("User.DHCCKBDicLinkAttr","#addattrlist",function(ret){
			if(ret=="0")
			{
				$('#AttrWin').dialog('close');
				$("#addattrlist").datagrid('reload');
				QueryDicList();
			}
					
		}
	)	
}
//��������ˢ��
function AttrRefreshData()
{
	$HUI.searchbox("#attrtreecode").setValue("");
	var searcode=$HUI.searchbox("#attrtreecode").getValue();
	var AddextraAttrValue = "AttrFlag"
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+AddextraAttrValue;
	$("#attrtree").tree('options').url =encodeURI(uniturl);
	$("#attrtree").tree('reload');
}
///����������
function findattrTree(searcode)
{
	var extraAttrValue = "AttrFlag" 	// �ֵ���(��������ֵ)
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#attrtree").tree('options').url =encodeURI(uniturl);
	$("#attrtree").tree('reload');
}
///�����ֵ���
function finddicTree(searcode)
{
	var AddextraAttrValue = "DictionFlag" 	// �ֵ���(��������ֵ)
	if(searcode==""){
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+AddextraAttrValue;
	}else{
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+AddextraAttrValue;
	}
	$("#dicextratree").tree('options').url =encodeURI(uniturl);
	$("#dicextratree").tree('reload');
}
///��������
function Refreshdic()
{
	$HUI.searchbox("#dictreecode").setValue("");
	var AddextraAttrValue = "DictionFlag"
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+AddextraAttrValue;
	$("#dicextratree").tree('options').url =encodeURI(uniturl);
	$("#dicextratree").tree('reload');
}
// ʵ���ѯ
function QueryWinDicList()
{
	var params = $HUI.searchbox("#entityCode").getValue();
	var AddextraAttrValue="ModelFlag";
	$('#entitygrid').datagrid('load',{
		extraAttr:extraAttr,
		extraAttrValue:AddextraAttrValue,
		params:params
	}); 
}
function InitPageInfoWin()
{
	$HUI.searchbox("#entityCode").setValue("");
	QueryWinDicList();
}
/// ɾ��
function DelLinkAttr(){

	removeCom("User.DHCCKBDicLinkAttr","#addattrlist")
}
///ˢ��datagrid
function reloadPagedg()
{
	$("#diclist").datagrid("reload");    
}
//�����ֵ�ָ��ť-tree
function ResettreeParref()
{
var node=$("#dictree").tree('getSelected');//ѡ��Ҫ�޸ĵ���
	if (node != null) {
		$HUI.dialog("#resetparref").open();
	/// ��ʼ��combobox
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
        dicParref = option.value;  //ѡ��ָ���ֵ�id
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("newparrefid",url,'',option).init(); 
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫ�޸ĵ�Ԫ�أ�','warning');
		 return;		
}		
}
///�����ֵ�ָ��ť-datagrid
function ResetParref()
{
var rowsData = $("#subdiclist").datagrid('getSelected'); //ѡ��Ҫ�޸ĵ���
	if (rowsData != null) {
		$HUI.dialog("#resetparref").open();
	/// ��ʼ��combobox
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
        dicParref = option.value;  //ѡ��ָ���ֵ�id
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("newparrefid",url,'',option).init(); 
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫ�޸ĵ�Ԫ�أ�','warning');
		 return;		
}
}




/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
