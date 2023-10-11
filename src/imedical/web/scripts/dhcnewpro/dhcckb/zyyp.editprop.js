//===========================================================================================
// Author��      qunianpeng
// Date:		 2019-06-28
// Description:	 �°��ٴ�֪ʶ��-ʵ��ά������
//===========================================================================================

var editRow = 0;
var subEditRow = 0; 
var valeditRow = 0;
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "ModelFlag" 	// ʵ����(��������ֵ)
var parref = getParam("parref");	// ����ҩƷid
var dicParref = getParam("dicParref");	// ҩƷʵ��id
var EntLinkId="";					// ����Id
var property="" ;  //ѡ������
/// ҳ���ʼ������
function initPageDefault(){
	InitButton();			// ��ť��Ӧ�¼���ʼ��
	InitCombobox();			// ��ʼ��combobox
	InitDataList();			// ʵ��DataGrid��ʼ������
	InitSubDataList();  	// ����DataGrid��ʼ������
	InitAttrValueList();	// ���������б�DataGrid��ʼ������
	//InitAddgridDataList();	// ����datagrid��ʼ������
	InitTextGridList();		// text���͵���ʷ���ݱ�����

}

/// ��ť��Ӧ�¼���ʼ��
function InitButton(){

	$("#InsertComOrigin").bind("click",InsertComDrug);	// ��������
	$("#insert").bind("click",InsertRow);	// ��������
	
	$("#save").bind("click",SaveRow);		// ����
	
	$("#delete").bind("click",DeleteRow);	// ɾ��
	
	//$("#find").bind("click",QueryDicList);	// ��ѯ
	
	$("#reset").bind("click",InitPageInfo);	// ����	
	
	$("#add_btn").bind("click",AddBtn);		// ����������
	
	$("#del_btn").bind("click",DelBtn);		// ������ɾ��
	
	/// ����.������ѯ
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
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
	
	$HUI.radio("[name='FilterCK']",{
        onChecked:function(e,value){
	       var param=LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;
           var url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=QueryDrugCatTree&attrID="+EntLinkId+"&EntyId="+parref+"&chkFlag="+this.value+"&param="+param;
		   $("#mygrid").tree('options').url =encodeURI(url);
		   $('#mygrid').tree('reload');
        }
     });
	
}

/// ��ʼ��combobox
function InitCombobox(){
		
	/// ��ʼ�����������
	var option = {
		panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	        dicParref = option.value;
	 		if((option.text=="��ҩ")||(option.text=="�г�ҩ")){
		    	$("#InsertComOrigin").show();  
		    }else
		    {
			    $("#InsertComOrigin").hide();   
			}
	       	QueryDicList();
	    },
	    loadFilter:function(data){                
                for(var i = 0; i < data.length; i++){
                    if(data[i].text != "��ҩ����" && data[i].text != "��ҩ��Ƭ"){
                        data.splice(i,1);
                        //����splice������data�е�ĳ����ŵ�ֵɾ���ˣ�������������˳���������ǰ�������-1,�ᵼ�²�������δ����ɸѡ
                        i--;
                    }
                }
                return data;
        }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue+"&drugType="+InitDrugType();
	new ListCombobox("dicType",url,'',option).init(); 	
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
			{field:'dicID',title:'rowid',hidden:true},
			{field:'dicCode',title:'����',width:200,align:'left',editor:texteditor},
			{field:'dicDesc',title:'����',width:300,align:'left',editor:texteditor},
			{field:'parref',title:'���ڵ�id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'parrefDesc',title:'���ڵ�',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDr',title:'����',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDesc',title:'��������',width:300,align:'left',editor:texteditor,hidden:true}
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
 			parref=rowData.dicID;  
		   	SubQueryDicList();		 
			setTimeout(InitComboboxSub,500);
		}, 
		onDblClickRow: function (rowIndex, rowData) { }
		  
	}
	var params = ""
	var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+parref+"&params="+params+"&drugType="+InitDrugType();
	
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}

/// ����DataGrid��ʼ����ͨ����
function InitSubDataList(){
	
	// ����columns	
	var columns=[[   
			{field:'attrID',title:'����id',width:60,align:'left',hidden:false},
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
		onDblClickRow:function(rowIndex,rowData){  
 			setcelLink(rowIndex,rowData)
 			var editors = $('#linkattrlist').datagrid('getEditors', rowIndex);                   
            for (var i = 0; i < editors.length; i++){  
                var e = editors[i];  
               
                if((e.field == "AttrValue")&&(e.type=="text")) {  		//e.type=="textarea"||
                   	$(e.target).bind("blur",function(){  
	          				$("#linkattrlist").datagrid('endEdit', rowIndex); 
	          				var selItem=$("#linkattrlist").datagrid('getRows')[rowIndex];
	          				
	                        var ListData = "" +"^"+ parref +"^"+ EntLinkId +"^"+ "" +"^"+ selItem.AttrValue.replace(/\^/g,"") +"^"+ "" +"^"+ "";
	                      
	                        saveTypeData(ListData,e.type)
                    });  
               }  
               if((e.field == "AttrValue")&&(e.type=="textarea")) {
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

/// ��������ֵtreeGrid��ʼ����
function InitAttrValueList(){
						
	/* // ����columns
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
		         if($("#mygrid").tree('find',AttrArray[i])==null){continue;}
		         $("#mygrid").tree('checkNode',AttrArray[i]);
		    } 
	    }		  
	}
	
	var params = ""
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonNew&attrID=99&input=" //$URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryLibItemDs";
	new ListTreeGrid('mygrid', columns, uniturl, option).Init();	 */
	var url = ""  //$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref 
	var option = {
		height:$(window).height()-105,   ///��Ҫ���ø߶ȣ���Ȼ����չ��̫��ʱ����ͷ�͹�����ȥ�ˡ�
		multiple: true,
		lines:true,
		fitColumns:true,
		checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//�Ƿ�����顣Ĭ��true  �˵����⣬����������
		animate:true,
        onClick:function(node, checked){
	      
	    },
	    onLoadSuccess: function(node, data){
			
			var AttrIdList=serverCall("web.DHCCKBDicLinkAttr","QueryEntyLinkAttr",{"EntyId":parref,"AttrCode":EntLinkId})
	        var AttrArray=AttrIdList.split(",");
	        for (var i=0;i<AttrArray.length;i++){
		         if($("#mygrid").tree('find',AttrArray[i])==null){continue;}
		         var n=$("#mygrid").tree('find',AttrArray[i])
		         $("#mygrid").tree('check',n.target);
		    } 
		}
	};
	new CusTreeUX("mygrid", url, option).Init();
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
			dgObj.width=200;
			if((jsonObj.rows[i].Code.indexOf("Id")>=0)||(jsonObj.rows[i].Code=="dicGroupFlag"))
			{
				dgObj.hidden=true;
			} 
			if(jsonObj.rows[i].edtstr==""){ //Ĭ�ϸ�ʽ
				dgObj.editor=textEditor;
			}else{		//ά���ĸ�ʽ
				var tempeditor=jsonObj.rows[i].edtstr;		//��̨��ʽ��
				var tempObj={};								//�༭��ʽ����
				optionobj={};								//option ����
				tempObj.type=tempeditor.split("@")[0];		//�༭��ʽ
				optionobj.valueField=tempeditor.split("@")[1];
				optionobj.textField=tempeditor.split("@")[2];
				optionobj.editable=tempeditor.split("@")[3];
				optionobj.url=$URL+"?"+tempeditor.split("@")[5];
				optionobj.panelHeight=200;
				optionobj.mode="remote";
				tempObj.options=optionobj;
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
		var params = parref +"^"+ attrID	;
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
			$.messager.alert('��ʾ','����ɹ���','info');
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
		parref:dicParref,
		params:params
	}); 
}

/// ʵ��datagrid����
function InitPageInfo(){	

	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	
	SubQueryDicList();
}

/// ��ѯ������ҳ��
function SubQueryDicList(){

	var params=dicParref+"^"+parref+"^"+property;

	var options={}
	options.url=$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrListData&params="+params+"&drugType="+InitDrugType();

	$('#linkattrlist').datagrid(options);
	$('#linkattrlist').datagrid('load',params);
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

	var $width="780";
	var $height="500";
	$(".div-common").hide();
	$("#dsou").val("");		
	$("#myWin").show();
	$HUI.searchbox("#myChecktreeDesc").setValue("");
	$("input[name='FilterCK'][type='radio']").radio('setValue',false);
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
		var param=LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;
		var options={}
		options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=QueryDrugCatTree&attrID="+attrID+"&input="+"&param="+param;
		$('#mygrid').tree(options);
		$('#mygrid').tree('reload');
		
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
	var dicID ="";
	if((parrefObj==null)&&(parref!="")){
		dicID=parref;
	}else{
		dicID = $g(parrefObj.dicID);
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
	var tmpparref ="";
	if((parrefObj==null)&&(parref!="")){
		tmpparref=parref;
	}else{
		tmpparref = $g(parrefObj.dicID)
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
			var attrArr=$('#mygrid').tree('getChecked');
			if(($g(attrArr.length) != 0)&&($g(attrArr.length) != "")){
				linkAttrDr = attrArr[0].id;
			}
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
		var attrArr=$('#mygrid').tree('getChecked');
		if(attrArr.length==0){
			var params= "" +"^"+ tmpparref +"^"+ linkRowID +"^"+""+"^"+ "";
		}else{
			for (var i=0;i<attrArr.length;i++){
				var nodeId=attrArr[i].id;
				var node=$('#mygrid').tree('find',nodeId)
				var isLeaf = $("#dictree").tree('isLeaf',node.target);
				//if(!isLeaf){continue;}
				var tmp= "" +"^"+ tmpparref +"^"+ linkRowID +"^"+ nodeId +"^"+ "";
				dataList.push(tmp);
				
			}
			var params=dataList.join("&&");
		}
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
				var e = $("#addgrid").datagrid('getColumnOption',fileds[j]);
				//var dicDataType=serverCall("web.DHCCKBDicLinkAttr","GetAddAttrCode",{"queryCode":fileds[j],"queryDicID":"","AttrLinkCode":"DataTypeProp"})
				if(e.editor.type=="combobox"){continue;}		//���������ݲ��洢
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
			$.messager.popover({msg: '����ɹ�����',type:'success',timeout: 1000});
			if(flag==1){
				$HUI.dialog("#myWin").close();
			}
			 
			//SubQueryDicList();   //�����ˢ��
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
	var desc=$HUI.searchbox("#myChecktreeDesc").getValue();
	$("#mygrid").tree("search", desc)
	/* var input = 
	var param=LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;
	var url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=QueryDrugCatTree&attrID="+EntLinkId+"&input="+input+"&param="+param
	$("#mygrid").tree('options').url =encodeURI(url);
	$('#mygrid').tree('reload');  */
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
///�ϴ�
function initUploadPic(){
	var fileName="";
	var d = new Date();
	var curr_date = d.getDate();
    var curr_month = d.getMonth() + 1; 
    var curr_year = d.getFullYear();
    var curdate = curr_year+""+curr_month+""+curr_date;
	$("#uploadify").uploadify({
		//buttonClass:"uploadify-button-a",
		buttonText:"�ϴ�ͼƬ"
		//fileObjName:"FileStream",
		//formData:{"fileName":fileName},
		//removeCompleted:true,
		//'uploader': "dhcckb.upload.csp?dirname=\\dhcnewpro\\dhcckb\\picture\\"+curdate+"\\", //'websys.file.utf8.csp',
	    ///'swf': '../scripts/dhcnewpro/dhcckb/util/uploadify/uploadify.swf',
	    //'fileTypeExts':'*.gif; *.jpg; *.png',
	    //height:30,   
	    //width:100,
	    //auto:true,
	    //'onUploadComplete' : function(file) {           //��ÿ���ļ��ϴ����ʱ���������۳ɹ����ǳ����������֪���ϴ��ɹ����ǳ�����ʹ�� onUploadSuccess��onUploadError �¼���
	       
	    //},
	    /*'onUploadSuccess' : function(file, data, response) {
			var imgUrl = $.parseJSON(data).fileFullName;
			var ip = $.parseJSON(data).ip;
			var params = recordId+"^"+imgUrl+"^"+UserId;
		},
		'onUploadError' : function(file, errorCode, errorMsg, errorString) {
			//alert('The file ' + file.name + ' could not be uploaded: ' + errorString);
		},
		onComplete: function (evt, queueID, fileObj, response, data) {
				//alert(response);
		},
	    'multi': true  */                               //Ĭ��ֵtrue���Ƿ�������ļ��ϴ���
    });
}
///��������Դ
function InsertDsource(flag)
{
	var datacode=""
	if(flag==1){
		datacode=$.trim($HUI.searchbox("#myChecktreeDesc").getValue());
	}else{
		datacode=$.trim($("#dsou").val());
	}
	
	var ListData="" +"^"+ datacode +"^"+ datacode +"^"+ EntLinkId;
	runClassMethod("web.DHCCKBRuleMaintain","saveOrUpdateData",{"params":ListData,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		if (jsonString == 0){
			$.messager.popover({msg: '����ɹ�����',type:'success',timeout: 1000});
		}else{
			 $.messager.alert('��ʾ','����ʧ�ܣ�ʧ�ܴ���'+jsonString,'warning');
		}					
	})
}
function InitComboboxSub()
{
	//����
    var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrComboxData"  
    $HUI.combobox("#propertyComBox",{
	     				url:uniturl,
	     				valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(ret){
							var param=dicParref+"^"+parref+"^"+ret.value;
							$('#linkattrlist').datagrid('load',{
							params:param
							}); 
						}
	   })		
}
// ����ͬԴҩƷ
// shy
function InsertComDrug()
{
//url:$URL+'?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource='+jsonString[j].source+'&filed='+jsonString[j].Filed,
    var uniturl = $URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource=127&filed=EqToUnitProp"  
    $HUI.combobox("#dicEqunitA",{
	     				url:uniturl,
	     				valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(ret){
						}
	   })			 
    $HUI.combobox("#dicEqunitB",{
	     				url:uniturl,
	     				valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(ret){
						}
	   })		
	
	var rowsData = $("#diclist").datagrid('getSelected');
	if(rowsData==null){
		$.messager.alert("��ʾ","û��ѡ��ͬԴҩƷ!");
		return;
	}
	$("#InsertComDicWin").show();
	$HUI.combobox("#dicDesc").setValue("");	
	var option = {
		modal:true,
		collapsible : false,
		minimizable : false,
		maximizable : false,
		border:true,
		closed:"true"
	};
	var title = "���ͬԴҩƷ";		
	new WindowUX(title, 'InsertComDicWin', '680', '260', option).Init();	
}
function closeDicWin()
{
	$("#InsertComDicWin").window('close');
}
function saveComDrug()
{	debugger;
	var rowsData = $("#diclist").datagrid('getSelected');
	var paref = rowsData.parref;
	var dicID = rowsData.dicID;
	var comDrugName = $("#dicName").val();
	var comDrugSpec = $("#dicSpec").val();
	var comDrugAppNum = $("#dicAppNum").val();
	var comDrugEqunitNum = $("#dicEqunitNum").val();
	var comDrugEqunitA = $("#dicEqunitA").combobox('getValue');
	var comDrugEqunitB = $("#dicEqunitB").combobox('getValue');
	if((comDrugName=="")||(comDrugSpec=="")||(comDrugAppNum=="")||(comDrugEqunitNum=="")||(comDrugEqunitA=="")||(comDrugEqunitB==""))
	{
		$.messager.alert("��ʾ","������ҩƷ��Ϣ��");
		return;
	}
	debugger;
	var params="^"+comDrugName+"^"+comDrugName+"^"+paref; 
	var property=comDrugSpec+"^"+comDrugAppNum+"^"+comDrugEqunitNum+"^"+comDrugEqunitA+"^"+comDrugEqunitB;   //�����׼�ĺš���Ч��λ                 
	runClassMethod("web.DHCCKBDiction","InsertComDrug",{"params":params,"property":property,"dicID":dicID,"LgUserID":LgUserID,"LgHospID":LgHospID,"ClientIPAddress":ClientIPAdd,"paref":paref},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
	            	closeDicWin();
	            	return false;
	           	}else{
				           $.messager.popover({msg: '�޸�ʧ�ܣ�',type:'success',timeout: 1000});
	            		return false;
				        }
				        
	 })
}
///����������֮��
window.onload = function(){
	if(parref!=""){
		$("#mainPanel").layout("hidden","west");
		SubQueryDicList();
		
	}
}

/// ҩƷ����
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })

