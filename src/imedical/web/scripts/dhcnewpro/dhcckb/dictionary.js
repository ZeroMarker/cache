//===========================================================================================
// Author��      qunianpeng
// Date:		 2019-01-04
// Description:	 �°��ٴ�֪ʶ��-�ֵ�����
//===========================================================================================

var editRow = 0,editsubRow=0;
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "DictionFlag" 	// �ֵ���(��������ֵ)
var parref="";
var IP=ClientIPAdd;
var ChkValue=""
var indexFlag=""
var CDCode=""						//ld 2022-9-20 ��������ж�
/// ҳ���ʼ������
function initPageDefault(){
	InitParams();
	InitButton();		// ��ť��Ӧ�¼���ʼ��
	InitCombobox();		// ��ʼ��combobox
	InitDataList();		// ҳ��DataGrid��ʼ������
	InitTree();     	// ��ʼ������
	InitSubDataList()	// �ֵ��
	//initaddattrGrid();	// ��������
}

/// ҩƷ����
function InitParams(){
	
	drugType = getParam("DrugType");	

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
			{field:'CDCode',title:'����',width:200,align:'left',editor:texteditor,hidden:false},
			{field:'CDDesc',title:'����',width:300,align:'left',editor:texteditor},
			{field:'Parref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'ParrefDesc',title:'���ڵ�',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'����',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"֪ʶ����",width:200,align:'left',hidden:true},
			{field:'DataType',title:"��������",width:200,align:'left',hidden:true}
			/* {field:'Operating',title:'����',width:380,align:'left',formatter:SetCellOperation} */
			
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
		pageSize:50,
		pageList:[50,100,150],		
 		onClickRow:function(rowIndex,rowData){ 	     
		   //SubQueryDicList(rowData.ID)
		   parref = rowData.ID;	
		   hiddenColumn(rowData);
		   CDCode=rowData.CDCode; //ld 2022-9-20 ��������ж���
		   //var params=parref +"^"+ extraAttr +"^"+ "ExtraProp";
		   //$("#addattrlist").datagrid("load",{"params":params});
		   switchMainSrc(parref)
		   if(rowData.DataType=="tree"){
			   $("#treediv").show();
			   $("#griddiv").hide();
			  
			   //kml 2020-03-05 ҩѧ���������
			   /* var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+parref; */
			   //ld 2022-9-21 �����ֵ����ͼ���tree  ��������ֵ�
			   if (CDCode=="DefinitionRuleData"){
				var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNodeDefRule&id="+parref;
				}else{
				var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+parref;	
				}
			   $('#dictree').tree('options').url = uniturl;
			   $('#dictree').tree('reload');
		   }else{
			   $("#treediv").hide();
			   $("#griddiv").show();
			   $("#subdiclist").datagrid("load",{"id":parref});
		   }
		  ShowIgnore(rowData.CDCode);
		   
		}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow == 0) { 
                $("#diclist").datagrid('endEdit', editRow); 
            } 
            $("#diclist").datagrid('beginEdit', rowIndex); 
            var editors = $('#diclist').datagrid('getEditors', rowIndex);                   
            for (var i = 0; i < editors.length; i++)   
            {  
                var e = editors[i]; 
              	$(e.target).bind("blur",function()
              	  {  
                   $("#diclist").datagrid('endEdit', rowIndex); 
                  });   
            } 
            editRow = rowIndex; 
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
        },
        loadFilter: function (data) {	     
        	var loadData = [];                       
          	if (drugType =="Herbal"){	 // ��ʱ�����ֵ� 2021/10/12 qnp      	
	        	for (i=0; i<data.rows.length-1; i++){		        	
			    	if ((data.rows[i].CDDesc == "��ҩ;���ֵ�")||(data.rows[i].CDDesc =="��ҩƵ���ֵ�")||(data.rows[i].CDDesc =="����Ӧ���ֵ�")||(data.rows[i].CDDesc =="��ҩ��Ƭ�ֵ�")||(data.rows[i].CDDesc =="��ҩ�����ֵ�")||(data.rows[i].CDDesc =="ҩ����Ϣ�ֵ�")){
			        	loadData.push(data.rows[i]);
			       	} 
		        }
		        var loadObj = {}
		        loadObj.total = loadData.length;
		        loadObj.rows = loadData;
				return loadObj;		
	        }else{
		       	return data;
		    }
		}		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params="+"&drugType="+InitDrugType();
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}


/// ��ť��Ӧ�¼���ʼ��
function InitButton(){

	$("#insert").bind("click",InsertRow);	// ��������
	
	$("#save").bind("click",SaveRow);		// ����
	
	$("#delete").bind("click",DeleteRow);	// ɾ��
	
	$("#find").bind("click",QueryDicList);	// ��ѯ
	
	$("#reset").bind("click",InitPageInfo);	// ����
	
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
	//$("#acdataflag").bind("click",AcDataFlag1);	// ��ʵ
	
	$("#acdataflag").bind("click",function(){       //wangxuejian 2021-05-19
       AcDataFlag("confirm")    //���ݺ�ʵ
     });
     
    $("#cancelAcflag").bind("click",function(){
       AcDataFlag("unconfirm")    //����ȡ����ʵ
     });
	
	$("#grantauth").bind("click",GrantAuth);	// ҽԺ��Ȩ
	
	$("#businessauth").bind("click",businessAuth);	// ҽԺ��Ȩ
	
	$("#grantauthB").bind("click",GrantAuth);	// ҽԺ��Ȩ
	
	$("#businessauthB").bind("click",businessAuth);	// ҽԺ��Ȩ
	
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
	        $HUI.combotree("#drugcattree").setValue("");
	        ChkValue=this.value;
	       	var seavalue=$HUI.searchbox("#myChecktreeDesc").getValue();
	       	finddgList(seavalue);
        }
     });
     
     ///��ѯ����
     $('#FindTreeText').searchbox({
	    searcher:function(value,name){
		   reloadTree();
	    }	   
	});	
	
	$("#reviewMan").bind("click",ReviewManage);	// ����
	
	
	///��������
	$("#selmulitm").bind("click",selItmMulSelRow);	
	
	///�����Ƴ�
	$("#remomulitm").bind("click",revItmMulSelRow);	
	
	$("#acalldataflag").bind("click",function(){       // xww 2021-08-23 ������ʵ
       AcAllDataFlag("confirm")    //���ݺ�ʵ
     })
     
    $('input[name="drugIngrType"]').hide();
    $("input:radio[name=drugIngrType]").hide();
    $(".radio hischeckbox_square-blue").hide();
    
    //$HUI.radio("[name='drugIngrType']").hide();
    
}

/// ��ʼ��combobox
function InitCombobox(){
	
	
	
	
}

// ��������
function InsertRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);		//�����༭������֮ǰ�༭����
	}
	$("#diclist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#diclist").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ����
function DeleteRow(){
	var rowsData = $("#diclist").datagrid('getSelected'); 						// ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫͣ����Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {
				var StopDate=SetDateTime("date");
				var StopTime=SetDateTime("time");
				SetFlag="stop"        //ͣ�����ݱ��
				DicName="DHC_CKBCommonDiction"
				dataid=rowsData.ID
				Operator=LgUserID
	  			runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":LgUserID,"OperateDate":StopDate,"OperateTime":StopTime,"Scope":"","ScopeValue":"","ClientIPAddress":IP,"Type":'log'},function(getString){
					if (getString == 0){
						Result = "�����ɹ���";
					}else if(getString == -1){
						Result = "��ǰ���ݴ�������ֵ,������ͣ��";
					}else{
						Result = "����ʧ�ܣ�";	
					}
				},'text',false);
				$.messager.popover({msg: Result,type:'success',timeout: 1000});
				reloadDatagrid();
			}
		}); 
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫͣ�õ���','warning');
		 return;
}
	
	 /*UsedDic
	var rowsData = $("#diclist").datagrid('getSelected'); 						// ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						$('#diclist').datagrid('reload'); //���¼���
					}else if (jsonString == "-1"){
						 $.messager.alert('��ʾ','�������ѱ�����,����ֱ��ɾ����','warning');
					}
					else{
						 $.messager.alert('��ʾ','ɾ��ʧ��.ʧ�ܴ���'+jsonString,'warning');
					}				
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
	*/
}


/// ����༭��
function SaveRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#diclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","info");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].CDCode=="")||(rowsData[i].CDDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!","info"); 
			return false;
		}

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc);
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = extraAttr +"^"+ extraAttrValue;

	//��������	 2020-03-27 kml SaveUpdate �ĳ� SaveUpdateNew
	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}else if(jsonString == -98){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');
		}else if(jsonString == -99){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		InitPageInfo();
		
		//$('#diclist').datagrid('reload'); //���¼���
	});
}

// ��ѯ
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();
	
	$('#diclist').datagrid('load',{
		extraAttr:extraAttr,
		extraAttrValue:extraAttrValue,
		params:params,
		drugType:InitDrugType()
	}); 
}

// ����
function InitPageInfo(){
	
	//$("#code").val("");
	//$("#desc").val("");
	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	

}
//==================================================�ֵ�ά������============================================================//
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
			{field:'ID',title:'rowid',hidden:true},
			{field:'ck',title:'����',checkbox:'true',width:80,align:'left'},  // xww 2021-08-23 ����������ʵ����������
			{field:'Operating',title:'����',width:60,align:'center',formatter:SetCellOper}, 
			{field:'CDCode',title:'����',width:300,align:'left',editor:'',formatter:tomodify,hidden:false},		//
			{field:'CDDesc',title:'����',width:300,align:'left',editor:texteditor},		//,formatter:tomodify
			{field:'Parref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'ParrefDesc',title:'���ڵ�',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'����',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"��������",width:200,align:'left',hidden:true},
			{field:'ConfirmFlag',title:'���״̬',width:50,align:'left',hidden:true},	// wangxuejian 2021-05-19 ���Ӻ�ʵ��
			{field:'ConfirmPerson',title:'�����',width:120,align:'left',hidden:true}	// sunhuiyong 2021-07-30 ���Ӻ�ʵ��
			//{field:'SetDisabled',title:'������',width:200,align:'center',formatter:SetDisabled},
			//{field:'Operating',title:'����',width:200,align:'center',formatter:SetCellOper} 
			
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		//singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90,10000],		
 		onClickRow:function(rowIndex,rowData){indexFlag=rowIndex;
 		  if (editsubRow != ""||editsubRow == 0) {    //wangxuejian 2021-05-21  �رձ༭�� 
                $("#subdiclist").datagrid('endEdit', editsubRow); 
            } 
 		}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editsubRow != ""||editsubRow == 0) { 
                $("#subdiclist").datagrid('endEdit', editsubRow); 
            } 
            $("#subdiclist").datagrid('beginEdit', rowIndex); 
            //var dbrowIndex=rowIndex
           var editors = $('#subdiclist').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 ʧȥ����رձ༭��                
            for (var i = 0; i < editors.length; i++)   
            {  
                var e = editors[i];
                var beginrowIndex=""
              	$(e.target).bind("blur",function()
              	  { 
              	  
                    $("#subdiclist").datagrid('endEdit', rowIndex);
              	    
                  });  
                   
                  /*e.target.mousedown(function(e){
	                  	
	                  $("#subdiclist").datagrid('endEdit', rowIndex); 	
	                  	 
                  	})*/
            } 
            
            editsubRow = rowIndex; 
        },
        onLoadSuccess:function(data){
	        var rowdata=$("#diclist").datagrid('getSelected');
	        if((rowdata)&&(rowdata.CDDesc=="��ҽ�����ֵ�")){
	        	$('#subdiclist').datagrid('showColumn', 'ConfirmPerson'); 
	        }else
	        {
		    	$('#subdiclist').datagrid('hideColumn', 'ConfirmPerson');   
		    }
            $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({});
            }
          });          
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByIDWhitinStop&id="+parref+"&parrefFlag=0&hospID="+LgHospID+"&groupID="+LgGroupID+"&locID="+LgCtLocID+"&userID="+LgUserID+"&parDesc=";
	new ListComponent('subdiclist', columns, uniturl, option).Init();
	
}
/// sub��������
function SubInsertRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);		//�����༭������֮ǰ�༭����
	}
	
	if(parref == ""){
		$.messager.alert("��ʾ","����ѡ��һ������ֵ�!","info");
		return;
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
	if(parref == ""){
		$.messager.alert("��ʾ","��ѡ��һ������ֵ�!","info");
		return;
	}

	var rowsData = $("#subdiclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","info");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].CDCode=="")||(rowsData[i].CDDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!","info"); 
			return false;
		}
		
		var tmp=$g(rowsData[i].ID) +"^"+ modify($g(rowsData[i].CDCode)) +"^"+ modify($g(rowsData[i].CDDesc)) +"^"+ parref;
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";
	
	//��������  2020-03-27 kml SaveUpdate �ĳ� SaveUpdateNew
	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		
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
					var StopDate=SetDateTime("date");
					var StopTime=SetDateTime("time");
				//	var link = "dhcckb.diclog.csp?DicName="+ DicName +"&Operator="+ LgUserID +"&SetFlag="+ SetFlag +"&dataid="+rowsData.ID+"&ClientIP="+IP;
				//	window.open(link,"_blank","height=400, width=650, top=200, left=400,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
				//return ;
				runClassMethod("web.DHCCKBDiction","UsedDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						SetFlag="stop"        //ͣ�����ݱ��
						DicName="DHC_CKBCommonDiction"
						dataid=rowsData.ID
						Operator=LgUserID
						//$HUI.dialog("#diclog").open();
						//var link = "dhcckb.diclog.csp?DicName="+ DicName +"&Operator="+ LgUserID +"&SetFlag="+ SetFlag +"&dataid="+dataid+"&ClientIP="+IP;
						//window.open(link,"_blank","height=400, width=650, top=200, left=400,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
					runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":LgUserID,"OperateDate":StopDate,"OperateTime":StopTime,"Scope":"","ScopeValue":"","ClientIPAddress":IP,'Type':'log'},function(getString){
							if (getString == 0){
								Result = "�����ɹ���";
							}else
							{
								Result = "����ʧ�ܣ�";	
							}
						},'text',false); 
						$.messager.popover({msg: Result,type:'success',timeout: 1000});
						//reloadDatagrid();
						$('#subdiclist').datagrid('deleteRow',indexFlag);   
						indexFlag="" 	
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
/*var rowsData = $("#subdiclist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){					
					if (jsonString==0){
						$('#subdiclist').datagrid('reload'); //���¼���
					}else if (jsonString == "-1"){
						 $.messager.alert('��ʾ','�������ѱ�����,����ֱ��ɾ����','warning');
					}
					else{
						 $.messager.alert('��ʾ','ɾ��ʧ��.ʧ�ܴ���'+jsonString,'warning');
					}
					
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
*/
}
function reloadDatagrid(){
	$("#diclist").datagrid("reload");
	$("#subdiclist").datagrid("reload");
}
function reloadTree(){
	var Input=$.trim($HUI.searchbox("#FindTreeText").getValue());
	if(Input==""){
		/* var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+parref+"&Input="; */
		if (CDCode=="DefinitionRuleData"){
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNodeDefRule&id="+parref+"&Input=";
		}else{
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref+"&Input=";	
		}
	}else{
		/* var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref+"&Input="+Input; */
		if (CDCode=="DefinitionRuleData"){
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNodeDefRule&id="+parref+"&Input="+Input;
		}else{
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref+"&Input="+Input; 
		//var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref+"&Input=";	
		}
	}
	$('#dictree').tree('options').url = encodeURI(url);	
	$('#dictree').tree('reload');
}
///��ʵ Sunhuiyong 2020-02-20
function AcDataFlag(conType){
	
	var rowsData = $("#subdiclist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		var ACDate=SetDateTime("date");
		var ACTime=SetDateTime("time");
		//SetFlag="confirm"        //��ʵ���ݱ��  wangxuejian 2021-05-19
		SetFlag=conType
		DicName="DHC_CKBCommonDiction"
		dataid=rowsData.ID
		Operator=LgUserID
		var confirmFlag=rowsData.ConfirmFlag
		if(((confirmFlag=="Y")||(confirmFlag=="�����"))&&(conType=="confirm"))
		{
		  $.messager.alert('��ʾ','�Ѿ��Ǻ�ʵ״̬�����ظ���ʵ','warning');
		   return;
		}
		if(((confirmFlag=="N")||(confirmFlag=="δ���"))&&(conType=="unconfirm"))
		{
		  $.messager.alert('��ʾ','�Ѿ���ȡ����ʵ״̬�����ظ�ȡ����ʵ','warning');
		   return;
		}
		runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":LgUserID,"OperateDate":ACDate,"OperateTime":ACTime,"Scope":"","ScopeValue":"","ClientIPAddress":IP,"Type":"log"},function(getString){
			if(conType=="confirm")
			{
				Result="��ʵ"
			}
			else if(conType=="unconfirm")
			{
				Result="ȡ����ʵ"
			}
			if (getString == 0){
				Results =Result+"�ɹ���";
			}else
			{
				Results = Result+"ʧ�ܣ�";	
			}
		},'text',false);
		$.messager.popover({msg: Results,type:'success',timeout: 1000});
			reloadDatagrid();
		}
	else{
		 $.messager.alert('��ʾ','��ѡ��Ҫ��ʵ����','warning');
		 return;
	}
		
}
//��Ȩ shy 2020-07-28
function GrantAuth(){

	var selecItm=$("#subdiclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	if((selecItm==null)&&(node==null))
	{
		$.messager.alert('��ʾ',"��ѡ��Ҫ��Ȩ����Ŀ��","info")
		return;	
	}
	var dicdataId=selecItm==null?node.id:selecItm.ID;
	if( dicdataId == null ){
		$.messager.alert('��ʾ',"��ѡ��Ҫ��Ȩ����Ŀ��","info")
		return;
	}
	var hideFlag=1;								//��ť���ر�ʶ
	var setFlag = "grantAuth";					//��Ȩ��ʶ
	var tableName = "DHC_CKBCommonDiction";		//��Ȩ��
	var dataId = dicdataId;					    //����Id
	
	if($('#win').is(":visible")){return;}  			//���崦�ڴ�״̬,�˳�
	
	var linkurl = 'dhcckb.diclog.csp?HideFlag='+hideFlag+'&DicName='+tableName+'&TableName='+tableName+'&dataid='+dataId+'&SetFlag='+setFlag+'&ClientIP='+ClientIPAdd+'&CloseFlag=1&Operator='+LgUserID+'&type=acc' 
	if ("undefined"!==typeof websys_getMWToken){
		linkurl += "&MWToken="+websys_getMWToken(); 
	}
	
	$('body').append('<div id="win"></div>');
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-w-save',
        title:'��Ȩ',
        modal:true,
        width:700,
        height:460,
        content:"<iframe id='otherdiclog' scrolling='auto' frameborder='0' src='"+linkurl+"' "+"style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
            text:'����',
            id:'save_btn',
            handler:function(){
                GrantAuthItemThis();                    
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
//��Ȩ shy 2020-07-28
function businessAuth(){
	
	var selecItm=$("#subdiclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	if((selecItm==null)&&(node==null))
	{
		$.messager.alert('��ʾ',"��ѡ��Ҫ��Ȩ����Ŀ��","info")
		return;	
	}
	var dicdataId=selecItm==null?node.id:selecItm.ID;
	if( dicdataId == null ){
		$.messager.alert('��ʾ',"��ѡ��Ҫ��Ȩ����Ŀ��","info")
		return;
	}
	var hideFlag=1;								//��ť���ر�ʶ
	var setFlag = "businessAuth";					//��Ȩ��ʶ
	var tableName = "DHC_CKBCommonDiction";		//��Ȩ��
	var dataId = dicdataId;					    //����Id
	
	if($('#win').is(":visible")){return;}  			//���崦�ڴ�״̬,�˳�
	
	var linkurl = "dhcckb.diclog.csp"+"?HideFlag="+hideFlag+"&DicName="+tableName+"&TableName="+tableName+"&dataid="+dataId+"&SetFlag="+setFlag+"&ClientIP="+ClientIPAdd+"&CloseFlag=1"+"&Operator="+LgUserID+"&type=acc";
	if ("undefined"!==typeof websys_getMWToken){
		linkurl += "&MWToken="+websys_getMWToken(); 
	}
	
	$('body').append('<div id="win"></div>');
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-w-save',
        title:'ҵ����Ȩ',
        modal:true,
        width:700,
        height:460,
        content:"<iframe id='otherdiclog' scrolling='auto' frameborder='0' src='"+linkurl+"' "+"style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
            text:'����',
            id:'save_btn',
            handler:function(){
                GrantAuthItemThis();                    
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
///��Ŀ��Ȩ
function GrantAuthItemThis(){

	var flag = $("#otherdiclog")[0].contentWindow.SaveManyDatas();	// ��ҳ����־
	if (flag){ // false
		$.messager.popover({msg: '��Ȩ�ɹ���',type:'success',timeout: 1000});
		$HUI.dialog('#win').close();
	}else{
		//$.messager.popover({msg: '��˶Ա����',type:'warn',timeout: 1000});
	}
	
}
/// sub ��ѯ
function SubQueryDicList(id){
	
	var params = $HUI.searchbox("#subQueryCode").getValue();
	
	$('#subdiclist').datagrid('load',{
		id:parref,
		parrefFlag:0,
		parDesc:params
	}); 
}

// ����
function InitSubPageInfo(){

	$HUI.searchbox('#subQueryCode').setValue("");
	SubQueryDicList();	

}

/// �ֵ������
function InitTree(){
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+parref+"&Input=";
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
	        var Flag=node.flag  //1:���õ�����  0���������� ld 2022-9-20�ж��Ƿ�Ϊ��������
	        if (Flag==1){
		       $("#treetoolbar").hide(); 							   
	        }else{
		        $("#treetoolbar").show();
		    	//$("#attrtree").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
		    }
	    },
	    onCheck:function(node,checked)
	    {
		    $(this).tree('select', node.target);
		    var Flag=node.flag  //1:���õ�����  0����������
	        if (Flag==1){
		      $("#treetoolbar").hide();
			}else{
		    	$("#treetoolbar").show();
		    	//$("#attrtree").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
		    }
		},
	    onContextMenu: function(e, node){
			
			e.preventDefault();
			$(this).tree('select', node.target);
			var node = $("#dictree").tree('getSelected');
			if (node == null){
				$.messager.alert("��ʾ","��ѡ�нڵ������!","info"); 
				return;
			}
				
			// ��ʾ��ݲ˵�
			/* $('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			}); */
			if(CDCode=="DefinitionRuleData"){
				var isLeaf = $("#dictree").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
	        	var Flag=node.flag  //1:���õ�����  0����������
	        	
	        	if (Flag==1){
		    	// ��ʾ��ݲ˵�
				$('#rightTermDelete').menu('show',{
				left: e.pageX,
				top: e.pageY
				});
					}
				else
					{
		    	// ��ʾ��ݲ˵�
				$('#rightTerm').menu('show', {
				left: e.pageX,
				top: e.pageY
				});
		    		}
			}else{
			// ��ʾ��ݲ˵�
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
				}
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
	//var desc=$.trim($("#FindTreeText").val());
	//$("#dictree").tree("search", desc)
	//$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //ȡ�����Ľڵ�ѡ��
	reloadTree();
}
/// ���÷���
function ClearData(){
	
	$HUI.searchbox("#FindTreeText").setValue("");
	//$('#dictree').tree('reload')
	//$('#dictree').tree('uncheckAll');
	//$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //ȡ�����Ľڵ�ѡ��
	reloadTree();
}
//�������ӽڵ㰴ť
function AddDataTree() {
	RefreshData();
	if (CDCode == "ICDDiagData"){	// icd�ֵ������޸��Զ������ qnp 20230510
		$("#treeCode").attr("disabled",false)
	}else{
		$("#treeCode").attr("disabled",true)
	}
	
	var options={};
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref;
	$('#parref').combotree(options);
	$('#parref').combotree('reload')
	
	$("#myWin").show();
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-w-save',
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
//����޸İ�ť
function UpdateDataTree() {
	
	RefreshData();
	
	if (CDCode == "ICDDiagData"){	// icd�ֵ������޸��Զ������ qnp 20230510
		$("#treeCode").attr("disabled",false)
	}else{
		$("#treeCode").attr("disabled",true)
	}
	
	$('#parref').combotree('reload',$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref)
	var record = $("#dictree").tree("getSelected"); 
	if (!(record))
	{	
		$.messager.alert('������ʾ','����ѡ��һ����¼!',"error");
		return;
	}
	var id=record.id;
	if (record){
		$("#treeID").val(record.id);
		var parentNode=$("#dictree").tree("getParent",record.target)	
		if (parentNode){		
			$('#parref').combotree('setValue', $g(parentNode.id));
		}
		$("#treeCode").val(record.code);
		$("#treeDesc").val(record.text);
	}
	$("#myWin").show(); 
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-w-save',
		resizable:true,
		title:'�޸�',
		modal:true,
		//height:$(window).height()-70,
		buttons:[{
			text:'����',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				SaveDicTree(1)
			}
		},{
			text:'�ر�',
			//iconCls:'icon-cancel',
			handler:function(){
				RefreshData();
				myWin.close();
			}
		}]
	});
}	
///ͣ��tree����-�����
function DelDataTree(){
	
	var dataList=[];
	var nodeArr=$('#dictree').tree('getChecked');			//����ͣ�� sufan20200313
	for (var i=0;i<nodeArr.length;i++){
		var nodeId=nodeArr[i].id;
		dataList.push(nodeId);
	}
	var params=dataList.join("^");
	if (nodeArr.length != 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫͣ����Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {
				var StopDate=SetDateTime("date");
				var StopTime=SetDateTime("time");
				runClassMethod("web.DHCCKBDiction","IsDicUsed",{"DicIdList":params},function(jsonString){
					if (jsonString == 0){
						SetFlag="stop"        //ͣ�����ݱ��
						DicName="DHC_CKBCommonDiction"
						dataid=params;
						Operator=LgUserID
						runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":LgUserID,"OperateDate":StopDate,"OperateTime":StopTime,"Scope":"","ScopeValue":"","ClientIPAddress":IP,"Type":"log"},function(getString){
							if (getString == 0){
								Result = "�����ɹ���";
							}else
							{
								Result = "����ʧ�ܣ�";	
							}
						},'text',false);
						$.messager.popover({msg: Result,type:'success',timeout: 1000});
						reloadTree();
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
   /*
	var record = $("#dictree").tree("getSelected"); 
	if (!(record))
	{	$.messager.alert('������ʾ','����ѡ��һ����¼!',"error");
		return;
	}
	//var childrenNodes = $("#dictree").tree('getChildren',record.target);
	var isLeaf = $("#dictree").tree('isLeaf',record.target);   /// �Ƿ���Ҷ�ӽڵ�
	if (isLeaf){
			$.messager.confirm('��ʾ', 'ȷ��Ҫɾ����ѡ��������?', function(r){
				if (r){			
					//��������
					runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":record.id},function(jsonString){
						if (jsonString != 0){
							$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
							$('#dictree').tree('reload'); //���¼���
							return;	
						}else{
							//$.messager.alert('��ʾ','����ɹ���','info');
							$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
							$('#dictree').tree('reload'); //���¼���
							return;
						}	
						
					});
				}
			});	
	}else{
		$.messager.confirm('��ʾ', '��<font color=red>��ǰ���������ӷ��࣬ɾ������ʱ��ͬʱɾ�����е��ӷ���</font>��<br/>ȷ��Ҫɾ����ѡ��������?', function(r){
				if (r){			
					//��������
					runClassMethod("web.DHCCKBDiction","DeleteAllDic",{"dicID":record.id},function(jsonString){
						if (jsonString != 0){
							$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
							$('#dictree').tree('reload'); //���¼���
							return;	
						}else{
							//$.messager.alert('��ʾ','����ɹ���','info');
							$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
							$('#dictree').tree('reload'); //���¼���
							return;
						}	
						
					});
				}
			});
		
	}

	*/
}
function TermRuleTree(){
	
	var node=$("#dictree").tree('getSelected');
	var id=node.id
	var Parref=parref
	var Info=LoginInfo
	var IP=ClientIPAdd
	if($('#win').is(":visible")){return;}  			//���崦�ڴ�״̬,�˳�
	$('body').append('<div id="win"></div>');
	
	var linkurl = "dhcckb.definitionrule.csp"+"?Parref="+parref+"&NodeId="+id+"&LoginInfo="+LoginInfo+"&ClientIPAdd="+ClientIPAdd;
	if ("undefined"!==typeof websys_getMWToken){
		linkurl += "&MWToken="+websys_getMWToken(); 
	}
	var myWin = $HUI.dialog("#win",{
        iconCls:'icon-w-save',
        title:'��������ֵ�',
        modal:true,
        width:700,
        height:500,
        content:"<iframe id='otherdiclog' scrolling='auto' frameborder='0' src='"+linkurl+"' style='width:100%; height:100%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[{
			text:'����',
			iconCls:'icon-save',
			id:'save_btn',
			handler:function(){				
				SaveTermRuleTree();
			}
		},{
			text:'�ر�',
			iconCls:'icon-close',
			handler:function(){
				CloseTreeWin();
			}
		}]
    });
	$('#win').dialog('center');
}
function CloseTreeWin(){
	$HUI.dialog("#win").close();
	uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNodeDefRule&id="+parref;
	$('#dictree').tree('options').url = uniturl;
	$('#dictree').tree('reload');
};

function SaveTermRuleTree(){
	$("#otherdiclog")[0].contentWindow.SaveTermRule();	
	
	}
function DelTermRuleTree(){
	var node=$("#dictree").tree('getSelected');
	var id=node.id
	var parentNode=$("#dictree").tree("getParent",node.target)
	var parentId=parentNode.id
	$.messager.confirm('��ʾ', '��<font color=red>ɾ��ʱ��ͬ��ɾ��������</font>��<br/>ȷ��Ҫɾ����ѡ��������?',function(r){
				if (r){			
					runClassMethod("web.DHCCKBDefinitionRule","DeleteTermRule",{"ID":id,"parentID":parentId},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�ErrCode'+jsonString,'warning');		
						return;	
					}else{
						$.messager.popover({msg: 'ɾ���ɹ�����',type:'success',timeout: 1000});
						uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNodeDefRule&id="+parref;
						$('#dictree').tree('options').url = uniturl;
						$('#dictree').tree('reload');
					}		
					});
				}
			});
	
	}
///����������
function SaveDicTree(flag){
			
	var treeID=$("#treeID").val();	
	var treeCode=$.trim($("#treeCode").val());
	if ((treeCode=="")&&(CDCode == "ICDDiagData")){
		$.messager.alert('������ʾ','���벻��Ϊ��!',"error");
		return;
	}
	var treeDesc=$.trim($("#treeDesc").val())
	if (treeDesc==""){
		$.messager.alert('������ʾ','��������Ϊ��!',"error");
		return;
	}
	///�ϼ�����
	if ($('#parref').combotree('getText')==''){
		$('#parref').combotree('setValue','')
	}
	
	var setParref = $('#parref').combotree('getValue')=="" ? parref : $('#parref').combotree('getValue') // ����Ϊ��,��Ĭ�Ϲ��ڷ����ֵ�����
	var params=$g(treeID) +"^"+ $g(treeCode) +"^"+ $g(treeDesc) +"^"+ $g(setParref)

	var attrData = "";

	//��������  2020-03-27 kml SaveUpdate �ĳ� SaveUpdateNew
	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		if (jsonString >= 0){
			//$.messager.alert('��ʾ','����ɹ���','info');
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			if(flag==1)
			{
				CloseWin();
			}
		}else if(jsonString == -98){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');
		}else if(jsonString == -99){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		if (CDCode=="DefinitionRuleData"){
		var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNodeDefRule&id="+parref;
			}else{
		var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref;	
			}
		$('#dictree').tree('options').url = uniturl;
		$('#dictree').tree('reload');
		
	});	
	
	//$('#mygrid').treegrid('reload');  // �������뵱ǰҳ������ 
	//$('#myWin').dialog('close'); // close a dialog

	//$.messager.alert('������ʾ',errorMsg,"error");

}
function CloseWin(){

	$HUI.dialog("#myWin").close();
};
///�������
function TAddDicTree(flag){	
	SaveDicTree(flag);
}
//������ͬ���ڵ㰴ť
function AddSameDataTree() {
	
	RefreshData();
	if (CDCode == "ICDDiagData"){	// icd�ֵ������޸��Զ������ qnp 20230510
		$("#treeCode").attr("disabled",false)
	}else{
		$("#treeCode").attr("disabled",true)
	}
	
	var options={};
	
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref
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
				SaveDicTree(1);
			}
		},{
			text:'�������',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				TAddDicTree(2);
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
		var parentNode=$("#dictree").tree("getParent",record.target)			
		$('#parref').combotree('setValue', $g(parentNode.id));
	}
}

/// �б�������л�
function switchMainSrc(parref){
	
	var linkUrl=""
	linkUrl = "dhcckb.addlinkattr.csp?parref="+parref;	// ��������
	if ("undefined"!==typeof websys_getMWToken){
		linkUrl += "&MWToken="+websys_getMWToken(); 
	}
		
	$("#tabscont").attr("src", linkUrl);	

}


///���ò�����ϸ����
function SetCellOper(value, rowData, rowIndex){
	
	var btn = "<a href='#' title='��������' class='icon icon-compare' style='color:#000;display:inline-block;width:16px;height:16px' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\"></a>";
	//var btn = "<img class='mytooltip' title='��������' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 

 return btn;  

}

/// ���Ա༭��
function OpenEditWin(ID,model,dataType){

	var linkUrl="",title=""
	if (model == "list"){
		
		linkUrl = "dhcckb.addlist.csp"
		title = "�ֵ�ά��"
		
	}else if (model =="prop"){
		
		linkUrl = "dhcckb.addattr.csp";
		title = "�����б�";
		
	}else if (model == "linkprop"){
		
		linkUrl = "dhcckb.addlinkattr.csp";
		title ="��������ά��";
		
	}else {
		linkUrl = "dhcckb.addlist.csp"
		title = "�ֵ�ά��"
	}	
	linkUrl += '?parref='+ID;
	if ("undefined"!==typeof websys_getMWToken){
		linkUrl += "&MWToken="+websys_getMWToken(); 
	}
	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'"></iframe>';

	if($('#winmodel').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:title,
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		maximized:true,
		maximizable:true,
		width:800,
		height:500
	});	

	$('#winmodel').html(openUrl);
	$('#winmodel').window('open');

}
//==================================================��������============================================================//
///tabs
function LoadattrList(title)
{  
	if (title == "��������"){ 
		 switchMainSrc(parref)
	}else{
		 InitSubDataList(); 
	}
}
///��������
function initaddattrGrid()
{
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	var Attreditor={  
		type: 'combobox',	//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'AttrDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'DLAAttrDr'});
				$(ed.target).val(option.value);
			},
			onShowPanel:function(){
				
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'DLAAttrCode'});
				var AddAttrID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'AttrDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAttrValue&AddAttrID="+ AddAttrID;
				$(ed.target).combobox('reload',unitUrl);
			}
		 }
	}
	///  ����columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult"
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'DLADicDr',title:'ʵ��ID',width:100,editor:textEditor,hidden:true},
		{field:'DLAAttrCode',title:'����id',width:150,editor:textEditor,hidden:true},
		{field:'DLAAttrCodeDesc',title:'��������',width:200,editor:textEditor},	
		{field:'DLAAttrDr',title:'����ֵid',width:80,editor:textEditor,hidden:true},	
		/* {field:'DLAAttrDesc',title:'����ֵ����',width:200,editor:Attreditor},	 */	
		{field:'DLAAttrDesc',title:'����ֵ����',width:300,editor:textEditor},
		{field:'DLAResult',title:'��ע',width:200,editor:textEditor,hidden:true}
	]];
	///  ����datagrid
	var option = {
		singleSelect : true,
	    onClickRow: function (rowIndex, rowData) {		//������ѡ���б༭
           editaddRow=rowIndex;
        },
        onDblClickRow: function (rowIndex, rowData) {		//˫��ѡ���б༭
           editaddRow=rowIndex;
           ShowAllData();
        }
	};
	
	var params=parref +"^"+ extraAttr ;
	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryAddLinkAttr&params="+params;
	new ListComponent('addattrlist', columns, uniturl, option).Init();
}
/// ���ݼ��ϣ�ȫ����
function ShowAllData(){

	var attrrow = $('#addattrlist').datagrid('getSelected');	// ��ȡѡ�е���  
	if ($g(attrrow) == ""){
		$.messager.alert('��ʾ','��ѡ��һ���������Խ���ά����','info');
		return;
	}
	$("#AttrWin").show();
	
	SetTabsInit();
      
    var myWin = $HUI.dialog("#AttrWin",{
        iconCls:'icon-write-order',
        resizable:true,
        title:'���',
        modal:true,
        //left:400,
        //top:150,
        buttonAlign : 'center',
        buttons:[{
            text:'����',
            id:'save_btn',
            handler:function(){
                SaveFunLib();                    
            }
        },{
            text:'�ر�',
            handler:function(){                              
                myWin.close(); 
            }
        }],
        onClose:function(){

        }
    });
	$('#AttrWin').dialog('center');
	$('#tabOther').tabs('select',0);  
	
	var AddextraAttrValue = "AttrFlag" 	// �ֵ���(��������ֵ)
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+AddextraAttrValue;
	$("#attrtree").tree('options').url =(uniturl);
	$("#attrtree").tree('reload');
	
	
	$('#tabOther').tabs({
		onSelect:function(title){
			if (title == "����"){
				var AddextraAttrValue = "AttrFlag" 	// �ֵ���(��������ֵ)
				var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+AddextraAttrValue;

				$("#attrtree").tree('options').url =(uniturl);
				$("#attrtree").tree('reload');
				
			}else if(title == "�ֵ�"){
				var AddextraAttrValue = "DictionFlag" 	// �ֵ���(��������ֵ)
				var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+AddextraAttrValue;

				$("#dicextratree").tree('options').url =(uniturl);
				$("#dicextratree").tree('reload');
				$("#entitygrid").datagrid("unselectAll");
				
			}else if (title == "ʵ��"){			  	
				var AddextraAttrValue = "ModelFlag" 	// �ֵ���(��������ֵ)
				var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+AddextraAttrValue+"&params=";

				$("#entitygrid").datagrid('options').url =(uniturl);
				$("#entitygrid").datagrid('reload');
				$("#dicgrid").datagrid("unselectAll");	
				$("#attrtree").tree("unselectAll");	     
			}
		}
	});
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
///����ָ���ֵ�-����
function SaveParrefData()
{
	/*var selecItm=$("#subdiclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	var dicId=selecItm==null?node.id:selecItm.ID;
	*/
	var selecItmStr=$("#subdiclist").datagrid('getChecked');
	var j = '';
	    for (var k = 0; k < selecItmStr.length; k++) {
	        if (j != '')
	            j += '^';
	        j += selecItmStr[k].ID;
	    }
	var selecItm=$("#subdiclist").datagrid('getSelected');
	var dicId = "";
	
	if(selecItm!=null){
		if(k)
		{
			dicId=j;	
		}else
		{
			dicId=	selecItm.ID;
		}
	}else{
	var nodes = $('#ruleTree').tree('getChecked');
    var s = '';
	    for (var i = 0; i < nodes.length; i++) {
	        if (s != '')
	            s += '^';
	        s += nodes[i].id;
	    }
    var node = $("#ruleTree").tree('getSelected');
	    if(s)
	    {
			dicId=s;	    
		}else
		{
			dicId=node.id;	
		}
	}
	if(dicParref==""){
		$.messager.alert("��ʾ","��ѡ���ֵ䣡","info");
		return;
	}
	
	runClassMethod("web.DHCCKBDiction","UdpDictionStr",{"DicIdStr":dicId,"DictionId":dicParref},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
	            	$("#subdiclist").datagrid('reload');
	            	$HUI.dialog("#resetparref").close();
	            	return false;
	           	}else{
		           	if(data==-1){
			           	$.messager.popover({msg: 'ת���ֵ䲻����ʵ�壡',type:'success',timeout: 1000});
			           $HUI.dialog("#resetparref").close();
	            		return false;
			        }else{
				        $.messager.popover({msg: '�ƶ��޸�ʧ�ܣ�',type:'success',timeout: 1000});
				       $HUI.dialog("#resetparref").close();
	            		return false;
				    }
		        }
	 })
		
}
///����ָ���ֵ�-����
function SaveParrefDataOld()
{
	var selecItm=$("#subdiclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	var dicId=selecItm==null?node.id:selecItm.ID;
	if(dicParref==""){
		$.messager.alert("��ʾ","��ѡ���ֵ䣡","info");
		return;
	}
	runClassMethod("web.DHCCKBDiction","UdpDiction",{"DicId":dicId,"DictionId":dicParref},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
	            	$("#subdiclist").datagrid('reload');
	            	$HUI.dialog("#resetparref").close();
	            	return false;
	           	}else{
		           	if(data==-1){
			           	$.messager.popover({msg: '�������ڹ����������ã�',type:'success',timeout: 1000});
			           $HUI.dialog("#resetparref").close();
	            		return false;
			        }else{
				        $.messager.popover({msg: '�ƶ��޸�ʧ�ܣ�',type:'success',timeout: 1000});
				       $HUI.dialog("#resetparref").close();
	            		return false;
				    }
		        }
	 })
		
}
///����ҩƷ����  sufan 20200316
function BatchData()
{
	
	var node = $("#dictree").tree("getSelected");
	if(node==null){
		$.messager.alert('��ʾ',"����ѡ��ҩѧ���࣡","info");
		return;
	}
	$('#myChecktreeWin').window({
		title:'����ҩƷ����',   
	    width:900,    
	    height:560,    
	    modal:true,
	    collapsible:false,
	    minimizable:false,
	    maximizable:false
	 
	}); 
	
	InitCatdrugList();
	$HUI.combotree("#drugcattree",{
		url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+parref,
		editable:true,
		onSelect:function(node){
			var selnode = $("#dictree").tree("getSelected");
			var drugdesc=$HUI.searchbox("#myChecktreeDesc").getValue();
			var params = selnode.id +"^"+ drugdesc +"^"+ ChkValue +"^"+ node.id;
			$("#myChecktree").datagrid('load',{"params":params});
		}
	})	
	
}
///���ط���ҩƷ�����б�
function InitCatdrugList()
{
	///  ����columns
	var columns=[[
		{field:'ck',checkbox:'true'},
		{field:'Id',title:'Id',width:100,hidden:'true'},
		{field:'Operat',title:'����',formatter:SetLinkOp},
		{field:'Code',title:'ҩƷ����',width:100,align:'center'},
		{field:'Desc',title:'ҩƷ����',width:150,align:'center'},
		{field:'CatDesc',title:'�����ķ���',width:150,align:'center'},
	]];
	
	///  ����datagrid
	var option = {
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],	
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
          
        }
	};
	var node = $("#dictree").tree("getSelected");
	var params = node.id;
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryCatLinkDrug&params="+params;
	new ListComponent('myChecktree', columns, uniturl, option).Init(); 
}
function finddgList(drugdesc)
{
	var node = $("#dictree").tree("getSelected");
	var params = node.id +"^"+ drugdesc +"^"+ ChkValue;
	$("#myChecktree").datagrid('load',{"params":params});
}
function SetLinkOp(value, rowData, rowIndex)
{
	
	if (rowData.Link == "0"){
		var html = "<a href='#' class='icon icon-compare' style='color:#000;display:inline-block;width:16px;height:16px' onclick='selItmSelRow("+rowIndex+")'>����</a>";
	}else{
		var html = "<a href='#' class='icon icon-compare' style='color:#000;display:inline-block;width:16px;height:16px' onclick='revItmSelRow("+rowIndex+")'>�Ƴ�</a>";
	}
    return html;
}

function SetDateTime(flag)
{
	var result=""
	runClassMethod("web.DHCCKBWriteLog","GetDateTime",{"flag":flag},function(val){	
	  result = val
	},"text",false)
	return result;
}
///����
function selItmSelRow(rowIndex)
{
	var node = $("#dictree").tree("getSelected");
	var rowData=$("#myChecktree").datagrid('getData').rows[rowIndex];
	var DrugId=rowData.Id;
	var DrugCatAttrId=rowData.DrugCatAttrId;
	
	var ListData="" +"^"+ DrugId +"^"+ DrugCatAttrId +"^"+ node.id +"^"+ "";
	
	runClassMethod("web.DHCCKBDicLinkAttr","InsText",{"ListData":ListData},
    	function(data){
        	if(data==0){
            	$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
            	
           	}
           	$("#myChecktree").datagrid('reload');
 	})
}
///��������sufan 2021-04-06
function selItmMulSelRow()
{
	var node = $("#dictree").tree("getSelected");
	var rowData = $("#myChecktree").datagrid('getSelections');
	if(rowData.length==0){
		$.messager.alert('��ʾ',"��ѡ����Ҫ������ҩƷ!","info");
		return false;
	}
	var dataList = [];
	for(var i=0; i<rowData.length; i++){
		var DrugId = rowData[i].Id;
		var DrugCatAttrId = rowData[i].DrugCatAttrId;
		var tempList = "" +"^"+ DrugId +"^"+ DrugCatAttrId +"^"+ node.id +"^"+ "";
		dataList.push(tempList);
	}
	var listData = dataList.join("&&");
	runClassMethod("web.DHCCKBDicLinkAttr","InsMulPhacla",{"listData":listData},
    	function(data){
        	if(data==0){
            	$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
            	
           	}
           	$("#myChecktree").datagrid('reload');
 	})
}
///�Ƴ�
function revItmSelRow(rowIndex)
{
	var node = $("#dictree").tree("getSelected");
	var rowData=$("#myChecktree").datagrid('getData').rows[rowIndex];
	var DrugId=rowData.Id;
	var DrugCatAttrId=rowData.DrugCatAttrId;
	var ListData=DrugId +"^"+ DrugCatAttrId +"^"+ node.id
	
	runClassMethod("web.DHCCKBDiction","revRelation",{"ListData":ListData},
	function(data){
    	if(data==0){
        	$.messager.popover({msg: '�Ƴ��ɹ���',type:'success',timeout: 1000});
       	}
       	$("#myChecktree").datagrid('reload');
	})
}
///�����Ƴ�sufan 2021-04-06
function revItmMulSelRow()
{
	var node = $("#dictree").tree("getSelected");
	var rowData = $("#myChecktree").datagrid('getSelections');
	if(rowData.length==0){
		$.messager.alert('��ʾ',"��ѡ����Ҫ������ҩƷ!","info");
		return false;
	}
	var dataList = [];
	for(var i=0; i<rowData.length; i++){
		
		var DrugId = rowData[i].Id;
		var DrugCatAttrId = rowData[i].DrugCatAttrId;
		var tempList = DrugId +"^"+ DrugCatAttrId +"^"+ node.id
		dataList.push(tempList);
	}
	var listData = dataList.join("&&");
	runClassMethod("web.DHCCKBDiction","revMulRelation",{"listData":listData},
    	function(data){
        	if(data==0){
            	$.messager.popover({msg: '�Ƴ��ɹ���',type:'success',timeout: 1000});
            	
           	}
           	$("#myChecktree").datagrid('reload');
 	})
}

///�滻�����ַ��ķ��� sufan 20200513
function modify(str)
{
	var str=str.replace("^","��")   //�滻Ϊ�ѹ���������ţ���ѧ������� "��";
	return str;
}
function tomodify(value, rowData, rowIndex)
{
	//var value=value.replace("��","^")   //�滻Ϊ�ѹ���������ţ���ѧ������� "��";
	return value;
	var dgvalue=rowData.CDCode;
	return dgvalue.replace('��',"^")  ;
}

/// ��������
function ReviewManage()
{
	var selectDataType = $("#diclist").datagrid('getSelected').CDCode; // ѡ����ֵ�����
	var selectItem = "";	// ѡ����ֵ�����
	var selecItm=$("#subdiclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	if((selecItm==null)&&(node==null))
	{
		$.messager.alert('��ʾ',"��ѡ��һ�����ݣ�","info")
		return;	
	}
	var selectItem=selecItm==null?node.id:selecItm.ID;
	OpenReviewWin(selectDataType,selectItem);
}

///����ҩƷ����  qunianpeng 2021/5/13
function BatchDataTab()
{
	
	var node = $("#dictree").tree("getSelected");
	if(node==null){
		$.messager.alert('��ʾ',"����ѡ��ҩѧ���࣡","info");
		return;
	}
	var rowsData = $("#diclist").datagrid('getSelected'); 	
	var selDataID = rowsData.ID||"";
	if($('#batchDataTab').is(":visible")){return;}  			//���崦�ڴ�״̬,�˳�
	
	var linkrul = "dhcckb.addcatlinkdrug.csp"+"?selDataID="+selDataID+"&selCatID="+node.id;
	if ("undefined"!==typeof websys_getMWToken){
		linkrul += "&MWToken="+websys_getMWToken(); 
	}	
	$('body').append('<div id="batchDataTab"></div>');
	var myWin = $HUI.dialog("#batchDataTab",{
        iconCls:'icon-w-save',
        title:'�������',
        modal:true,
        width:1200,
        height:650,
        content:"<iframe id='batchDataTabframe' scrolling='auto' frameborder='0' src='"+linkrul+"' " +"style='width:100%; height:99%; display:block;'></iframe>",
        buttonAlign : 'center',
        buttons:[
        	/*{
            text:'����',
            id:'save_btn',
           	 	handler:function(){
                	GrantAuthItem();                    
            	}
       		},*/
       		{
            text:'�ر�',
            	handler:function(){                              
                	myWin.close(); 
            	}
        	}
        ]
    });
	$('#batchDataTab').dialog('center');
}

/// ҩƷ����
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}

/// xww 2021-08-23 ������ʵ�������ֵ�����
function AcAllDataFlag(conType){
	var rowsData = $('#subdiclist').datagrid('getSelections');		//֪ʶ����Ŀ
	if(rowsData.length==0)
	{
		$.messager.alert('��ʾ','��ѡ��Ҫ��ʵ����','warning');
		return;
	}
	var ACDate=SetDateTime("date");
	var ACTime=SetDateTime("time");
	SetFlag=conType
	DicName="DHC_CKBCommonDiction"
	Operator=LgUserID
	var confirmFlag=rowsData.ConfirmFlag;
	var dataList = []
	for(var i=0;i<rowsData.length;i++)
	{
		var tmp = rowsData[i].ID;
		dataList.push(tmp);
	}
	var params=dataList.join("&&");
	

	/*if((confirmFlag=="Y")&&(conType=="confirm"))
	{
	  $.messager.alert('��ʾ','�Ѿ��Ǻ�ʵ״̬�����ظ���ʵ','warning');
	   return;
	}
	if((confirmFlag=="N")&&(conType=="unconfirm"))
	{
	  $.messager.alert('��ʾ','�Ѿ���ȡ����ʵ״̬�����ظ�ȡ����ʵ','warning');
	   return;
		}*/
	runClassMethod("web.DHCCKBWriteLog","InsertAllDicLog",{"DicDr":DicName,"params":params,"Function":SetFlag,"Operator":LgUserID,"OperateDate":ACDate,"OperateTime":ACTime,"Scope":"","ScopeValue":"","ClientIPAddress":IP,"Type":"log"},function(getString){
		if(conType=="confirm")
		{
			Result="��ʵ"
		}
		else if(conType=="unconfirm")
		{
			Result="ȡ����ʵ"
		}
		if (getString == 0){
			Results =Result+"�ɹ���";
		}else
		{
			Results = Result+"ʧ�ܣ�";	
		}
	},'text',false);
	$.messager.popover({msg: Results,type:'success',timeout: 1000});
	reloadDatagrid();
		
}

/// �����ֵ�������
function  hiddenColumn(rowData){
	
	if (rowData.CDDesc.indexOf("�ɷ��ֵ�")!=-1){
		//$('#subdiclist').datagrid('hideColumn', 'Operating');
	}
 	
}

/// �����ֵ������ʾ��������
function ShowIgnore(code){
	
	var codeArr = ["DrugData","ChineseDrugData","ChineseHerbalMedicineData","GeneralData","PrescriptionCopeData","GeneralFromData"];
	codeArr.push("DrugProNameData");
	codeArr.push("DrugCategoryData");
	codeArr.push("ingredientData");
	codeArr.push("ExcipientData");
	codeArr.push("DrugPreMetData");
	codeArr.push("DrugFreqData");
	codeArr.push("FormData");
	
	if (codeArr.indexOf(code) > -1){
		$("#reviewMan").show();
		$("#catIgnoreBtn").show();	
	}
	else{
		$("#reviewMan").hide();
		$("#catIgnoreBtn").hide();

	}
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
