//===========================================================================================
// Author��      qunianpeng
// Date:		 2019-06-28
// Description:	 �°��ٴ�֪ʶ��-�ֵ�ά������
//===========================================================================================

var editRow = 0;
var subEditRow = 0; 
var valeditRow = 0;
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "DictionFlag" 	// �ֵ���(��������ֵ)
var parref = "";					// ����ҩƷid
var dicParref = "";					// ҩƷʵ��id
var EntLinkId="";					// ����Id
var DataType=""
/// ҳ���ʼ������
function initPageDefault(){
	
	InitButton();			// ��ť��Ӧ�¼���ʼ��
	InitCombobox();			// ��ʼ��combobox
	InitDataList();			// ʵ��DataGrid��ʼ������
	InitSubDataList();  	// ����DataGrid��ʼ������
	InitAttrValueList();	// ���������б�DataGrid��ʼ������
	//InitAddgridDataList();	// ����datagrid��ʼ������
	InitTextGridList();		// text���͵���ʷ���ݱ�����
	InitTree();
	
	$('#showlist').panel('resize', {
        height:$(window).height()-105
    }); 
     if (DataType=="tree"){
		$("#dictree").resizable({
	   		maxHeight : $(window).height()-105
		});
    }else{
		$("#diclist").datagrid('resize', { 
            height : $(window).height()-105
   		});
	}	

}

/// ��ť��Ӧ�¼���ʼ��
function InitButton(){

	$("#insert").bind("click",InsertRow);	// ��������
	
	$("#save").bind("click",SaveRow);		// ����
	
	$("#delete").bind("click",DeleteRow);	// ɾ��
	
	//$("#find").bind("click",QueryDicList);	// ��ѯ
	
	$("#reset").bind("click",InitPageInfo);	// ����	
	
	$("#treereset").bind("click",InitTreeData);	// ����		
	
	$("#add_btn").bind("click",AddBtn);		// ����������
	
	$("#del_btn").bind("click",DelBtn);		// ������ɾ��
	
	$('#queryCode').searchbox({
		
	    searcher:function(value,name){
		    if (DataType == "tree"){
				$("#dictree").tree("search", value)
			}else{
				QueryDicList();
			}
	    }	   
	});		
	
	$('#treequery').searchbox({
		
	    searcher:function(value,name){
		    if (DataType == "tree"){
				$("#dictree").tree("search", value)
			}
	    }	   
	});	
	
	///���Ĳ���
	$('#myChecktreeDesc').searchbox({
	    searcher:function(value,name){
		    //var desc=$HUI.searchbox("#myChecktreeDesc").getValue();		   
			//$("#mygrid").treegrid("search", desc)	
	   		QueryTreeList();
	    }	   
	});	
	
	///�޸Ĺ����ֵ�
	$("#updDic").bind("click",UpdAttrDiction);
	$("#updTreeDic").bind("click",UpdAttrDiction);
	
}
function InitComboboxAll(){
		$("#dictree").tree("search", "")
		$('#linkattrlist').datagrid('loadData',[]);	    
	}
/// ��ʼ��combobox
function InitCombobox(){
	
	/// ��ʼ�����������
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	       dicParref = option.value;
	       runClassMethod("web.DHCCKBEditDiction","GetDicDataType",{'dicID':dicParref},function(ret){
				DataType=ret;
				},'text',false);
		   if(DataType=="tree")
		   	   {
			   $("#treediv").show();
			   $("#griddiv").hide();
			   $("#toolbartree").show();
			   // ҩѧ���࣬ͣ��+���� //kml 2020-03-09		
			   //var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+dicParref;
			   var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+dicParref+"&hospID="+LgHospID+"&groupID="+LgGroupID+"&locID="+LgCtLocID+"&userID="+LgUserID
			   $('#dictree').tree({url:uniturl}); 
			   //$('#dicTypetree').combobobox('select','106');
			   $("#diclist").datagrid("reload")
			   }
			   else
			   {
			   $("#treediv").hide();
			   $("#toolbartree").hide();	
			   $("#griddiv").show();
	       	   $("#diclist").datagrid("load",{"id":dicParref});
	       	   $("#dictree").tree("reload")
			   }

	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue+"&drugType="+InitDrugType();
	new ListCombobox("dicType",url,'',option).init(); 
	new ListCombobox("treeType",url,'',option).init();
	
	//�ֵ� sufan 20200212 ����
	$('#dicDesc').combobox({
		url:url,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		editable:false
	})
	
	
}

// �༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

/// ʵ��DataGrid��ʼ����ͨ����
function InitDataList(){
	
	// ����columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'����',width:200,align:'left',editor:texteditor},
			{field:'CDDesc',title:'����',width:300,align:'left',editor:texteditor},
			{field:'CDParref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDParrefDesc',title:'���ڵ�',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'����',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"��������",width:200,align:'left',hidden:true},
			{field:'CDLinkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true}
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
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){ 	   
 			parref=rowData.ID;  
		   	SubQueryDicList();		 
		}, 
		onDblClickRow: function (rowIndex, rowData) { }
		  
	}
	var params = ""
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+parref+"&parrefFlag=0&parDesc="+params;
	
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}

/// ����DataGrid��ʼ����ͨ����
function InitSubDataList(){
	
	// ����columns	
	var columns=[[   
			{field:'attrID',title:'����id',width:60,align:'left',hidden:true},
			{field:'attrCode',title:'���Դ���',width:180,align:'left'},
			{field:'attrDesc',title:'����',width:180,align:'left'},
			{field:'dataType',title:'��������',width:80,align:'left',hidden:true},
			{field:'AttrValue',title:'����ֵ',width:310,align:'left',hidden:false},
			{field:'Operating',title:'����',width:50,align:'center',formatter:SetCellOperation,hidden:true}
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
 			EntLinkId=rowData.attrID;
		}, 	
		onDblClickRow:function(rowIndex,rowData)
		{  
 			setcelLink(rowIndex,rowData)
 			var editors = $('#linkattrlist').datagrid('getEditors', rowIndex);                   
            for (var i = 0; i < editors.length; i++)
            {  
                  /* if((e.field == "AttrValue")&&(e.type=="textarea"||e.type=="text")) {  
                   	$(e.target).bind("blur",function(){  
                        if($.trim($(this).val())!="") {
	          				$("#linkattrlist").datagrid('endEdit', rowIndex); 
	                        var ListData = "" +"^"+ parref +"^"+ EntLinkId +"^"+ "" +"^"+ $(this).val() +"^"+ "" +"^"+ "";
	                        saveTypeData(ListData,e.type)
	                    }
                    });  
                   }*/  
                  var e = editors[i];      // wxj ie�� textarea ���治��ʹ 2021-05-21
                  if((e.field == "AttrValue")&&(e.type=="text")) 
                  {  		
                   	$(e.target).bind("blur",function(){  
	          				$("#linkattrlist").datagrid('endEdit', rowIndex); 
	          				var selItem=$("#linkattrlist").datagrid('getRows')[rowIndex];
	                        var ListData = "" +"^"+ parref +"^"+ EntLinkId +"^"+ "" +"^"+ selItem.AttrValue.replace(/\^/g,"") +"^"+ "" +"^"+ "";
	                        saveTypeData(ListData,e.type)
                    });  
                  }  
                 if((e.field == "AttrValue")&&(e.type=="textarea")) 
                  {
	               dataGridBindEnterEvent(rowIndex);
	              }  
              
            }  
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
	var params = "";
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrListData&params="+params;

	new ListComponent('linkattrlist', columns, uniturl, option).Init();			
}
/// �ֵ������
function InitTree(){
	var url = "" //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref 
	var option = {
		height:$(window).height()-105,   ///��Ҫ���ø߶ȣ���Ȼ����չ��̫��ʱ����ͷ�͹�����ȥ�ˡ�
		multiple: true,
		lines:true,
		fitColumns:true,
		animate:true,
        onClick:function(node, checked){
	        parref=node.id;        //����ID  
		   	SubQueryDicList();	
	       
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
}
/// ��������ֵtreeGrid��ʼ����
function InitAttrValueList(){
						
	// ����columns
	var columns=[[     
			{field:'id',title:'id',width:80,sortable:true,hidden:true},
			{field:'code',title:'����',width:80,sortable:true,hidden:true},
			{field:'desc',title:'����',width:360,sortable:true,hidden:false},
			{field:'_parentId',title:'parentId',width:80,sortable:true,hidden:true}				
		 ]]

	var option={	
		height:$(window).height()-105,
		idField: 'id',
		treeField:'desc',
		checkbox:true,
		fitColumns:true,	//����Ϊ true������Զ��������С�еĳߴ�����Ӧ����Ŀ�Ȳ��ҷ�ֹˮƽ����
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		lines:true,		
		showHeader:false,
		pagination:false,
		rownumbers:false,
		onDblClickRow: function (rowIndex, rowData) {	//˫��ѡ���б༭
        },
        onLoadSuccess:function(rowIndex, rowData){
	        var AttrIdList=serverCall("web.DHCCKBDicLinkAttr","QueryEntyLinkAttr",{"EntyId":parref,"AttrCode":EntLinkId})
	        var AttrArray=AttrIdList.split(",");
	        for (var i=0;i<AttrArray.length;i++){
		         if($("#mygrid").treegrid('find',AttrArray[i])==null){continue;}
		         $("#mygrid").treegrid('checkNode',AttrArray[i]);
		    } 
	    }		  
	}
	
	var params = ""
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonNew&attrID=99&input=" //$URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryLibItemDs";
	new ListTreeGrid('mygrid', columns, uniturl, option).Init();	
}


/// ����DataGrid��ʼ����
function InitAddgridDataList(attrCode,attrID,htmlType){
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ����columns	
	var columns=[];
	var Array=[],dgObj={};
	
	runClassMethod("web.DHCCKBDicLinkAttr","GetColumnsByDicCode",{"AttrId":"","DicCode":attrCode},function(jsonString){
		if(jsonString==""){ return;}
		var jsonObj=jsonString;
		for(var i=0;i<jsonObj.total;i++){
			dgObj={};
			dgObj.field=jsonObj.rows[i].Code;
			dgObj.title=jsonObj.rows[i].Desc;
			dgObj.align="center";
			dgObj.width=60;
			if((jsonObj.rows[i].Code.indexOf("Id")>=0)||(jsonObj.rows[i].Code=="dicGroupFlag"))
			{
				dgObj.hidden=true;
			}
			if(jsonObj.rows[i].edtstr==""){
				dgObj.editor=textEditor;
			}else{
				var tempeditor=jsonObj.rows[i].edtstr;
				var tempObj={};
				optionobj={};
				tempObj.type=tempeditor.split("@")[0];
				optionobj.valueField=tempeditor.split("@")[1];
				optionobj.textField=tempeditor.split("@")[2];
				optionobj.editable=tempeditor.split("@")[3];
				optionobj.url=$URL+"?"+tempeditor.split("@")[5];
				optionobj.panelHeight=tempeditor.split("@")[4];
				optionobj.mode="remote";
				tempObj.options=valueobj;
				dgObj.editor=tempObj;
			}
			Array.push(dgObj);
	 	}
		columns.push(Array);
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
	 		onClickRow:function(rowIndex,rowData){}, 	
	 		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	 			var fileds=$('#addgrid').datagrid('getColumnFields');
				var params=fileds.join("&&");
	 				runClassMethod("web.DHCCKBDicLinkAttr","getEditors",{"FiledList":params},function(jsonString){
					
					for(var j=0;j<jsonString.length;j++)
					{
						if(jsonString[j].editors=="combobox"){
							var e = $("#addgrid").datagrid('getColumnOption',jsonString[j].Filed);
							e.editor = {
								type:'combobox',
							  	options:{
								valueField:'value',
								textField:'text',
								mode:'remote',
								url:$URL+'?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource='+jsonString[j].source+'&filed='+jsonString[j].Filed,
								onSelect:function(option) {
									var ed=$("#addgrid").datagrid('getEditor',{index:subEditRow,field:option.filed});
									$(ed.target).combobox('setValue', option.text);
									var ed=$("#addgrid").datagrid('getEditor',{index:subEditRow,field:option.filed+"Id"});
									$(ed.target).val(option.value); 
								} 
							 }
						  }
						}	
					}
					if (subEditRow != ""||subEditRow == 0) { 
	                	$("#addgrid").datagrid('endEdit', subEditRow); 
	           		} 
		            $("#addgrid").datagrid('beginEdit', rowIndex); 
		            
		            subEditRow = rowIndex;
				})
	            
	        }
			  
		}
		var params = parref +"^"+ attrID;
		var uniturl = $URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params+"&Type="+htmlType;

		new ListComponent('addgrid', columns, uniturl, option).Init();
			
	},'json','false')	
}
///�˴�����Ҫ��̬��ֵ
function InitTextGridList()
{
	// ����columns	
	var columns=[[   
			{field:'id',title:'����id',width:60,align:'left',editor:texteditor,hidden:true},
			{field:'Result',title:'����',width:60,align:'left',editor:texteditor},
			{field:'dicGroupFlag',title:'dicGroupFlag',width:300,align:'left',hidden:true},
			{field:'Operating',title:'����',width:50,align:'center',formatter:SetCellUrl}	
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
	 		$("#myarea").val(rowData.Result);
	 	}
	}
	var params = "";	
	var uniturl = $URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params;

	new ListComponent('linklist', columns, uniturl, option).Init();		
}
/// ʵ��datagrid��������
function InsertRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);		//�����༭������֮ǰ�༭����
	}
	$("#diclist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {}
	});
	$("#diclist").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	editRow=0;
}

/// ʵ��datagridɾ��ѡ����
function DeleteRow(){
	 
	var rowsData = $("#diclist").datagrid('getSelected'); 						// ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						$('#diclist').datagrid('reload'); //���¼���
					}else{
						 $.messager.alert('��ʾ','ɾ��ʧ��.ʧ�ܴ���'+jsonString,'warning');
					}					
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ʵ��datagrid����༭��
function SaveRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#diclist").datagrid('getChanges');
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

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc);
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = extraAttr +"^"+ extraAttrValue;

	//��������
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			InitPageInfo();
			return;	
		}else{
			//$.messager.alert('��ʾ','����ɹ���','info');
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			InitPageInfo();
			return;
		}
		
		//$('#diclist').datagrid('reload'); //���¼���
	});
}

/// ʵ��datagrid��ѯ
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();

	$('#diclist').datagrid('load',{
		extraAttr:"DataSource",
		id:dicParref,
		parDesc:params
	}); 
}

/// ʵ��datagrid����
function InitPageInfo(){	

	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	
	SubQueryDicList();
}
function InitTreeData()
{
	$HUI.searchbox('#treequery').setValue("");
	$("#dictree").tree("search", "")
}
/// ��ѯ������ҳ��
function SubQueryDicList(){

	var params=dicParref+"^"+parref;
	var options={}
	//alert(params)
	options.url=$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrListData&params="+params;

	$('#linkattrlist').datagrid(options);
	$('#linkattrlist').datagrid('reload');
}

///����ֵ����
function setcelLink(rowIndex, rowData)
{
	
	 var e = $("#linkattrlist").datagrid('getColumnOption', 'AttrValue');
	 var DataSource = serverCall("web.DHCCKBRangeCat","GetAddAttrSource",{"queryDicID":rowData.attrID,"AttrLinkCode":"DataSource","AttrId":"","queryDicCode":""});		//����Դ
	 if(rowData.dataType=="textarea"){
		 e.editor = {type:'textarea'}
	 }else if(rowData.dataType=="combobox"){
		 e.editor = {type:'combobox',
				  	 options:{
						valueField:'value',
						textField:'text',
						mode:'remote',
						url:$URL+'?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource='+DataSource,
						onSelect:function(option) {
							var ListData = "" +"^"+ parref +"^"+ EntLinkId +"^"+ option.value +"^"+ "" +"^"+ "" +"^"+ "";
	                        saveTypeData(ListData,e.type)
						},
				  		onShowPanel:function(){
							
				    	}	  
					}
		 }
	 }else if((rowData.dataType=="datagrid")||(rowData.dataType=="tree")){
		 e.editor = {type:''}
		 AddAttrValue(rowData.attrID,rowData.dataType,rowData.attrCode);
	 }else{
		 e.editor = {type:'text'}
	 }
	
	 if (valeditRow != ""||valeditRow === 0) { 
            $("#linkattrlist").datagrid('endEdit', valeditRow); 
      } 
     $("#linkattrlist").datagrid('beginEdit', rowIndex); 
     valeditRow=rowIndex;
}

///�����ӽ������ò�����ϸ����
function SetCellOperation(value, rowData, rowIndex){

	var btn = "<img class='mytooltip' title='��������' onclick=\"AddAttrValue('"+rowData.attrID+"','"+rowData.dataType+"','"+rowData.attrCode+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn;  
}

///	�༭����ֵ���� 
function AddAttrValue(attrID,htmlType,attrCode){

	var $width="500";
	var $height="400";
	$(".div-common").hide();		
	$("#myWin").show();

	/// �������ͼ��ض�Ӧ������	
	if (htmlType == "textarea"){			
		$("#linkID").val("");
		$("#myarea").val("");
		var params = parref +"^"+attrID;
		var options={};
		options.url=$URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params+"&Type="+htmlType;
		$('#linklist').datagrid(options);
		$('#linklist').datagrid('reload');
			
	}else if (htmlType == "tree"){
		var options={}
		options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=QueryDrugCatTree&attrID="+attrID+"&input=" 
		$('#mygrid').treegrid(options);
		$('#mygrid').treegrid('reload');
		
	}else if(htmlType == "treegrid"){
	

	}else  if(htmlType == "datagrid"){
		InitAddgridDataList(attrCode,attrID,htmlType);		
		var options={}
		var params = parref +"^"+attrID;
		options.url=$URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params+"&Type="+htmlType;
		$('#addgrid').datagrid(options);
		$('#addgrid').datagrid('reload');
		
	}else if(htmlType == "checkbox"){
	
		
	}else{
		htmlType = "textarea";
		$("#myarea").val("");
		var params = parref +"^"+attrID;
		var options={};
		options.url=$URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryEntyAttr&params="+params+"&Type="+htmlType;
		$('#linklist').datagrid(options);
		$('#linklist').datagrid('reload');
	}	
	
	/// չʾά������
	$("#my"+htmlType).show();	
	
	/// ��ʼ���Ѿ�ά��������ֵ
	InitEditValue(attrID,htmlType);
	
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-write-order',
		resizable:true,
		title:'���',
		modal:true,
		//width:500,
		//height:480,
		width:$width,
		height:$height,
		buttonAlign : 'center',
		buttons:[{
			text:'����',
			iconCls:'icon-save',
			id:'save_btn',
			handler:function(){				
				SaveAttrValue();
			}
		},{
			text:'�ر�',
			iconCls:'icon-close',
			handler:function(){
				myWin.close();
			}
		}]
	});	
	
}

/// ��ʼ���������Ѿ�ά��������ֵ
function InitEditValue(attrID,htmlType){

	var parrefObj = $("#diclist").datagrid('getSelected');	// ʵ��
	var dicID="";
	if(parrefObj!=null){
		dicID = $g(parrefObj.ID);
	}
	var node=$("#dictree").tree('getSelected');
	if(node!=null){
		dicID=node.id;
	}
	
	
	
	runClassMethod("web.DHCCKBDicLinkAttr","GetAttrValueJson",{"dicID":dicID,"attrID":attrID,"htmlType":htmlType},function(jsonString){

		var obj=jsonString; //jQuery.parseJSON(jsonString);		
		if ($g(obj) != ""){
			
			if (htmlType == "textarea"){
				
				var rowsArr = $g(obj.rows);
				var result = "";
				var linkID = "";
				$.each(rowsArr,function(index,itmObj){
					
					result = result + $g(itmObj.result);
					linkID = $g(itmObj.linkID);		// �ı�����ֻ��һ����¼������ж�����¼���޸�ʱ�����浽���һ����¼��
				})	
				$("#myarea").val(result);
				$("#linkID").val(linkID);
			}	
		}else{
			 $.messager.alert('��ʾ','��ȡ����ʧ�ܡ�'+jsonString,'warning');
		}					
	},"json",false)
}

/// ��������������ֵ
function SaveAttrValue(){

	// ��ȡʵ��
	var parrefObj = $("#diclist").datagrid('getSelected');	// ʵ��
	
	var tmpparref="";
	
	if(parrefObj!=null){
		tmpparref = $g(parrefObj.ID);
	}
	var node=$("#dictree").tree('getSelected');
	if(node!=null){
		tmpparref=node.id;
	}
	if(tmpparref == 0){
		 $.messager.alert('��ʾ','��ѡ��һ��ҩƷ����','warning');
		 return;
	}
	
	// ��ȡ����
	var attrObj=$("#linkattrlist").datagrid('getSelected');	// ����
	var attrID=$g(attrObj.attrID); 
	var htmlType=$g(attrObj.dataType);						// ���Ե�չ����ʽ
	var DicCode=attrObj.attrCode;
	if(attrID == 0){
		 $.messager.alert('��ʾ','��ѡ��һ������','warning');
		 return;
	}
	
	var linkRowID=""	// 
	var linkAttrDr="";
	switch ($g(htmlType)) {
		
		case "textarea":
			linkAttrValue=$("#myarea").val();
			if ($g(linkAttrValue) == ""){
				 $.messager.alert('��ʾ','����д���ݣ�','info');
				 return;
			}
			linkRowID = $("#linkID").val();				
			break;
			
		case "tree":	
			var attrArr=$('#mygrid').treegrid('getCheckedNodes','checked');
			if(($g(attrArr.length) == 0)||($g(attrArr.length) == "")){
				 $.messager.alert('��ʾ','��ѡ��һ������','warning');
				 return;
			}
			linkAttrDr = attrArr[0].id;
			break;
		case "datagrid":
			linkRowID = $("#linkID").val();						//ʵ��ID
			break;	
		default:
			linkAttrValue=$("#myarea").val();
			if ($g(linkAttrValue) == ""){
				 $.messager.alert('��ʾ','����д���ݣ�','info');
				 return;
			}
			linkRowID = $("#linkID").val();				
			break;

	}
	SaveDataWithType(htmlType,attrID,tmpparref,DicCode);   	//���ñ��溯��  sufan 2019-11-18		

	return;
}

///���ݲ�ͬ��������������
function SaveDataWithType(htmlType,linkRowID,tmpparref,DicCode)
{
	var dataList=[];
	// ��ȡά��������ֵ
	if (($g(htmlType) == "textarea")||($g(htmlType) == "")){			//����textarea����
		var selItem=$("#linklist").datagrid('getSelected');
		var AttrLink="";
		if(selItem){
			AttrLink=selItem.id;
		}
		linkAttrValue=$("#myarea").val();
		var params=AttrLink +"^"+ tmpparref +"^"+ linkRowID +"^"+ "" +"^"+linkAttrValue;
			
	}else if (htmlType == "tree"){	
		var attrArr=$('#mygrid').treegrid('getCheckedNodes','checked');
		for (var i=0;i<attrArr.length;i++){
			var nodeId=attrArr[i].id
			var nodes=$('#mygrid').treegrid('getChildren',nodeId);
			if(nodes.length){continue;}
			var tmp= "" +"^"+ tmpparref +"^"+ linkRowID +"^"+ nodeId +"^"+ "";
			dataList.push(tmp);
		}
		var params=dataList.join("&&");
	}else if ((htmlType == "datagridinput")||(htmlType == "input")){
			
	}else if(htmlType == "datagrid"){			//����datagrid 
	
		if(subEditRow>="0"){
			$("#addgrid").datagrid('endEdit', subEditRow);
		}
		var rowsData = $("#addgrid").datagrid('getChanges');
		if(rowsData.length<=0){
			$.messager.alert("��ʾ","û�д���������!");
			return;
		}
		///ȡά������
		var fileds=$('#addgrid').datagrid('getColumnFields');
		var ListStr="0" +"^"+ tmpparref +"^"+ linkRowID +"^"+ "" +"^"+ ""
		dataList.push(ListStr);
		for(var i=0;i<rowsData.length;i++){
			var GroupNum=rowsData[i].dicGroupFlag;
			for (var j=1;j<fileds.length;j++){
				var ItmId=rowsData[i].Id==undefined?0:rowsData[i].Id
				//var dicDataType=serverCall("web.DHCCKBDicLinkAttr","GetAddAttrCode",{"queryCode":fileds[j],"queryDicID":"","AttrLinkCode":"DataTypeProp"})
				var e = $("#addgrid").datagrid('getColumnOption',fileds[j]);
				if(e.editor.type=="combobox"){continue;}	//���������ݲ��洢	
			    if(fileds[j]=="dicGroupFlag"){continue;}	//���ʶ���洢
				var ListData = ItmId +"^"+ tmpparref +"^"+ linkRowID +"^"+ rowsData[i][fileds[j]] +"^"+ fileds[j] +"^"+ i +"^"+ GroupNum;
				dataList.push(ListData);
			}
			
		} 
		var params=dataList.join("&&");
	
		
	}else if(htmlType == "checkbox"){
			
	}else{
		
	}
	
	//��������
	saveTypeData(params,htmlType,1)
	
}
function saveTypeData(params,htmlType,flag)
{
	
	runClassMethod("web.DHCCKBDicLinkAttr","saveDicAttrByType",{"ListData":params,"Type":htmlType,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�ErrCode'+jsonString,'warning');		
			return;	
		}else{
			//$.messager.alert('��ʾ','����ɹ���','info');
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			if(flag==1){
				$HUI.dialog("#myWin").close();
			}
			 
			SubQueryDicList();
			return;
		}		
	});
}
/// ����������
function AddBtn(){
		var fileds=$('#addgrid').datagrid('getColumnFields');
	var params=fileds.join("&&");
	runClassMethod("web.DHCCKBDicLinkAttr","getEditors",{"FiledList":params},function(jsonString){
		
		for(var j=0;j<jsonString.length;j++)
		{
			if(jsonString[j].editors=="combobox"){
				var e = $("#addgrid").datagrid('getColumnOption',jsonString[j].Filed);
				e.editor = {
					type:'combobox',
				  	options:{
					valueField:'value',
					textField:'text',
					mode:'remote',
					url:$URL+'?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource='+jsonString[j].source+'&filed='+jsonString[j].Filed,
					onSelect:function(option) {
						var ed=$("#addgrid").datagrid('getEditor',{index:subEditRow,field:option.filed});
						$(ed.target).combobox('setValue', option.text);
						var ed=$("#addgrid").datagrid('getEditor',{index:subEditRow,field:option.filed+"Id"});
						$(ed.target).val(option.value); 
					} 
				 }
			  }
			}	
		}
		
		if(subEditRow>="0"){
			$("#addgrid").datagrid('endEdit', subEditRow);		//�����༭������֮ǰ�༭����
		}
		$("#addgrid").datagrid('insertRow', {
			index: 0, // ������0��ʼ����
			row: {}
		});
		
		$("#addgrid").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
		subEditRow=0;
	})
}


/// ������ɾ��
function DelBtn()
{
	var rowsData = $("#addgrid").datagrid('getSelected'); //ѡ��Ҫɾ������
	var params = rowsData.Id;
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDicLinkAttr","DelData",{"params":params},function(jsonString){
					if (jsonString!="0")
					{
						$.messager.alert('��ʾ','ErrorCode:'+jsonString,'warning');
					}
					$('#addgrid').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
//�������Ľڵ�
function QueryTreeList()
{
	/*debugger;
	var params = $HUI.searchbox("#myChecktreeDesc").getValue();
	var url=$URL+"?ClassName=web.DHCCKBEditDiction&MethodName=GetTreeJson&parref="+dicParref+"&desc="+params 
	var options={}
	options.url=encodeURI(url);
	new CusTreeUX("dictree", url, options).Init();
	//$("#dictree").treegrid("options").url =encodeURI(url);
	//$('#dictree').treegrid('reload');
	///	var options={}
	/// options.url=$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrListData&params="+params;
	*/
	var desc=$HUI.searchbox("#myChecktreeDesc").getValue();
	$("#dictree").tree("search", desc)
	$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //ȡ�����Ľڵ�ѡ��
}
/// ����
function SetCellUrl(value, rowData, rowIndex){	
	var html = "<a href='#' onclick='delRow("+ rowData.id +")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
	return html;
}

function delRow(ItmId)
{
	if (ItmId != "") {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBDicLinkAttr","DelDicAttr",{"linkRowID":ItmId},function(jsonString){
					if(jsonString!=0){
						$.messager.alert('��ʾ',"ErrMsg:"+jsonString)
					}
					$('#linklist').datagrid('reload'); 
				})
			}
		});
	}
}

///�޸��ֵ����
function UpdAttrDiction()
{
	var selecItm=$("#diclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	if((selecItm==null)&&(node==null)){
		$.messager.alert('��ʾ','��ѡ��Ҫ�޸ĵ��ֵ����ݣ�')
		return;
	}
	if(node!=null){
		var isLeaf=$("#dictree").tree('isLeaf',node.target);
		if(isLeaf==false){
			$.messager.alert('��ʾ','��ѡ��ĩ���ڵ㣡')
			return;
		}
	}
	$("#UpdDicWin").show();
	$HUI.combobox("#dicDesc").setValue("");	
	var option = {
		modal:true,
		collapsible : false,
		minimizable : false,
		maximizable : false,
		border:true,
		closed:"true"
	};
	var title = "�޸Ĺ����ֵ�";		
	new WindowUX(title, 'UpdDicWin', '360', '150', option).Init();
}
function saveDiction()
{
	var selecItm=$("#diclist").datagrid('getSelected');
	var node=$("#dictree").tree('getSelected');
	var dicId=selecItm==null?node.id:selecItm.ID;
	var dictionId=$HUI.combobox("#dicDesc").getValue();
	if(dictionId==""){
		$.messager.alert("��ʾ","��ѡ���ֵ䣡");
		return;
	}
	runClassMethod("web.DHCCKBDiction","UdpDiction",{"DicId":dicId,"DictionId":dictionId},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
	            	$("#diclist").datagrid('reload');
	            	closeDicWin();
	            	return false;
	           	}else{
		           	if(data==-1){
			           	$.messager.popover({msg: '�������ڹ����������ã�',type:'success',timeout: 1000});
			           	closeDicWin();
	            		return false;
			        }else{
				        $.messager.popover({msg: '�ƶ��޸�ʧ�ܣ�',type:'success',timeout: 1000});
				        closeDicWin();
	            		return false;
				    }
		        }
	 })
}
function closeDicWin()
{
	$("#UpdDicWin").window('close');
}
///�����������
function dataGridBindEnterEvent(index)
{
	var editors = $('#linkattrlist').datagrid('getEditors',index);
	subEditRow=index;
	for(var i=0;i<editors.length;i++){
		var workEditor = editors[i];
		editors[i].target.attr("field",editors[i].field);
		editors[i].target.mousedown(function(e){
			var field=$(this).attr("field")
			var ed=$("#linkattrlist").datagrid('getEditor',{index:index, field:field});		 
			editdivComponent({
						  tarobj:$(ed.target),
						  filed:field,
						  input:$(this).val(),
						  htmlType:'textarea',
						  height:'260'
						})	
			});	
	}
}

function editdivComponent(opt,callback){
	
		var option={
			width: 445,
			height: 120,
			emrType:'review',
			htmlType:'radio',
			foetus:1
		}
		
		$.extend(option,opt);

		if ($("#win").length > 0){
			$("#win").remove();
		}
		var retobj={};	// ���ض���
			
		///������������
		var btnPos=option.tarobj.offset().top+ option.height;
		var btnLeft=option.tarobj.offset().left - tleft;
		
		if(option.foetus>1){
			option.height=option.height+32*(option.foetus-1)
		}
		$(document.body).append('<div id="win" style="width:'+ option.width +';height:'+option.height+';border:1px solid #E6F1FA;position:fixed;z-index:9999;background-color:#eee;"></div>') 
		var html='<div id="mydiv" class="hisui-layout" fit=true style="background-color:#eee;">'
		html=html+' <div data-options="region:\'center\',title:\'\',border:false,collapsible:false" style="background-color:#eee;height:'+option.height+'">';
		html=html+'<textarea id="divTable" type="text" border="1" class="hisui-validatebox" style="width:92%;height:180px;resize:none;margin:10px;!important" data-options="required:true"></textarea>';
		html=html+'</div>';
		html=html+'<div data-options="region:\'south\',title:\'\',border:false,collapsible:false" style="text-align:center;background-color:#eee;">';
		html=html+'		<a href="#" class="hisui-linkbutton" id="saveDivWinBTN"  style="width:60px" >����</a>';
		html=html+'		<a href="#" class="hisui-linkbutton"  id="removeDivWinBTN" style="width:60px" >�ر�</a>';
		html=html+'</div>';
		html=html+'</div>';
		$("#win").append(html);	
		$("#win").show();
		$.parser.parse($("#win"));
		setTimeout(function(){
			$("#divTable").focus();
		},100)
		
		if($.trim(option.input)!="")
		{
			$("#divTable").val(option.input);
		}
		var tleft = "";
		if((option.tarobj.offset().left+500)>document.body.offsetWidth){
			tleft= 500 - (document.body.offsetWidth - option.tarobj.offset().left);
		}
	
		//$("#win").css("left",option.tarobj.offset().left - tleft);
		//$("#win").css("top",option.tarobj.offset().top+ option.tarobj.outerHeight());
		var $left=option.tarobj.offset().left<option.width?option.tarobj.offset().left:(option.tarobj.offset().left-(document.body.offsetWidth/2-option.width));
		$("#win").css("left",$left);
		var winTop=option.tarobj.offset().top+ option.tarobj.outerHeight();		// win���붥����λ��
		var winHieght=option.height;											// win����Ŀ��
		var $top=($(window).height()-winTop)>winHieght?winTop:winTop-winHieght-30;
		$("#win").css("top",$top);		
		$("#divTable").find("td").children().eq(0).focus();
		$("#divTable").on('keyup',function(e){
			$(option.tarobj).val($("#divTable").val());
		})
		$("#saveDivWinBTN").on('click',function(){
			
			if (option.htmlType == "textarea"){
				$(option.tarobj).val($("#divTable").val());
			}
			var ListData = "" +"^"+ parref +"^"+ EntLinkId +"^"+ "" +"^"+ $.trim($("#divTable").val()).replace(/\^/g,"") +"^"+ "" +"^"+ "";
	        saveTypeData(ListData,"textarea")	
			$("#win").remove();
		})
		$("#removeDivWinBTN").on('click',function(){
				$("#win").remove();
		});
		$(document).keyup(function(event){
			
			switch(event.keyCode) {
				case 27:
					$("#win").remove();
				case 96:
					$("#win").remove();
			}
		});
		 $("#divTable").bind("blur",function()     //wxj 2021-05-21 ʧȥ����رձ༭�� ,����������
	                {
		              if (option.htmlType == "textarea"){
				     $(option.tarobj).val($("#divTable").val());
			            }
			         var ListData = "" +"^"+ parref +"^"+ EntLinkId +"^"+ "" +"^"+ $.trim($("#divTable").val()).replace(/\^/g,"") +"^"+ "" +"^"+ "";
	                  saveTypeData(ListData,"textarea")	
			          $("#win").remove();
	               })
		
}

/// ҩƷ����
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
