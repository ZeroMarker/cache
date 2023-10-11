/**
	xiaowenwu 
	2020-01-15
	����ά��
*/
var editDRow = "0",editRow="",editPRow="0"; 
var dicId="",num="",field="";
var saveDataSour=""; //�Ƿ�Ϊ�������Դ��ť�ı����¼�
var selArray = [{"value":"0","text":'�ѱ���'}, {"value":"1","text":'���ύ'},{"value":"2","text":'ȫ��'}];
$(function(){ 

	inittree();		//��ʼ������ά������
	initCombobox();
	//initDataTable(); //��ʼ������ά���ӱ�

})

function inittree(){
	
	$('#modelTree').combotree({
    	url:LINK_CSP+'?ClassName=web.DHCCKBRuleMaintain&MethodName=ListModelTree',
    	lines:true,
		animate:true,
		onSelect: function(rec){
			runClassMethod("web.DHCCKBRuleMaintain","ListModelDataGrid",{"dicId":rec.id},function(data){
				var json= eval('(' + data + ')');
				dicId=rec.id;
				var condvalue=$("#modellist").combobox('getValue');
				console.log(dicId)
				$('#modelTable').datagrid({			
					toolbar:"#modelToolbar",
					url:$URL+"?ClassName=web.DHCCKBRuleMaintain&MethodName=ListModelDataNew&parent="+dicId+"&params="+condvalue,
					columns:[json],
					headerCls:'panel-header-gray',
					iconCls:'icon-paper', 
					border:false,
					fit:true,
					fitColumns:true,
					singleSelect:true, 
					pagination:true,
					pageSize:15,
					pageList:[15,30,60],
					displayMsg: '��{total}��¼',
					onDblClickRow: function (rowIndex, rowData) {		//˫��ѡ���б༭
          			 	CommonRowClick(rowIndex,rowData,"#modelTable"); //�༭��
           				dataGridBindEnterEvent(rowIndex);				//���������������ʾ�ֵ�datagrid
           				
        			},
        			onClickRow:function(rowIndex, rowData){
	        			}
					});
			},"text");
	    }
	});
}	

///��ʼ��������
function initCombobox()
{
	$('#modellist').combobox({
		data:selArray,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option){
			if(dicId==""){
				$.messager.alert('��ʾ','����ѡ��ģ�壡')
				return;
			}
			var url=$URL+"?ClassName=web.DHCCKBRuleMaintain&MethodName=ListModelDataNew&parent="+dicId+"&params="+option.value;
			$('#modelTable').datagrid('options').url=url;
        	$("#modelTable").datagrid('reload');  
		} 
	})
}
//������������
function addModelRow(){
	var DrugLibaryID=serverCall("web.DHCCKBRuleMaintain","DrugLibaryDataID",{"dicId":dicId});  //��ȡģ��󶨵�Ŀ¼��ID������
	var array=DrugLibaryID.split("^")
	var ID=[array[0]];		//Ŀ¼ID��73��
	num=array[0];
	var catalog=array[1];	//Ŀ¼��������Ӧ֢��
	commonAddRow({'datagrid':'#modelTable',value:{"catalog":catalog,"catalogId":ID}})
	dataGridBindEnterEvent(0);
}

//���������������ʾ�ֵ�datagrid
function dataGridBindEnterEvent(index){
	
	editRow=index;
	var editors = $('#modelTable').datagrid('getEditors',index);
	
	for(var i=0;i<editors.length;i++){
		var workEditor = editors[i];
		editors[i].target.attr("field",editors[i].field);
		editors[i].target.mousedown(function(e){
				
				var DataDesc="",DataID=""
				field=$(this).attr("field")
				var fieldId=field+"Id";
				var ed=$("#modelTable").datagrid('getEditor',{index:index, field:field});		 
				var input = $(ed.target).val();														//����
				//var edId=$("#modelTable").datagrid('getEditor',{index:index, field:fieldId});		//��������ID
				//var fieldIdinput = $(edId.target).val();
				var isDataSource=serverCall("web.DHCCKBRuleMaintain","isDataSource",{'field':field}); //�Ƿ���Ҫ��������
				if((isDataSource==0)){
					var Array=[],dgObj={},Incolumns=[];
					var textEditor={
						type: 'text',//���ñ༭��ʽ
						options: {
							required: true //���ñ༭��������
						}
				}
				runClassMethod("web.DHCCKBRuleMaintain","QueryColumns",{"AttrcodeId":field,"DicCode":""},function(jsonString){	
					if(jsonString!=""){
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
					Incolumns.push(Array);
					}
					
					ruledivComponent({
								  tarobj:$(ed.target),
								  filed:field,
								  input:input,
								  htmlType:'datagrid',
								  height:'310',
								  Incolumns:Incolumns,
								  url:LINK_CSP+'?ClassName=web.DHCCKBRuleMaintain&MethodName=QueryDicByID&id='+field+"&parDesc="+encodeURIComponent(input),
								  columns:[[
								  	{field:'ID',hidden:true},
								  	{field:'CDDesc',title:'����',width:60},
								  
								  ]] 
								},function(rowData){
									var ed=$("#modelTable").datagrid('getEditor',{index:index, field:field});		 
									var input = $(ed.target).val();					//����
									var fieldIdinput="";
									if(input=="")
									{
										DataDesc=rowData.CDDesc;
									}
									else{
										DataDesc=input+","+rowData.CDDesc;   		//����
									}
									$(ed.target).val(DataDesc);
									if(DataID=="")
									{
										if((fieldIdinput=="")&&(input=="")){
											DataID=rowData.ID;
										}
										else{
											DataID=fieldIdinput+","+rowData.ID; 	//Id
										}
									}
									else{
										DataID=DataID+","+rowData.ID;
									}
									var IdEd=$("#modelTable").datagrid('getEditor',{index:index,field:field+"Id"});
									$(IdEd.target).val(DataID);
									
								})
							},'json','false')	
				}
			
		});
		
		
		
	}
}


/// ����������༭��
function saveModelRow(){
	if(!endEditing("#modelTable")){
		$.messager.alert("��ʾ","��༭��������!");
		return;
	}
	//2020-04-13 һ���Ա������
	var rowsData = $("#modelTable").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var opts = $('#modelTable').datagrid('getColumnFields');
	var dataListAll = [];
	for(var j=0;j<rowsData.length;j++){
		var dataList = [];
		for(var i=0;i<opts.length;i++){
			var colOpt=$('#modelTable').datagrid('getColumnOption',opts[i])
			if(colOpt.hidden===false){
				var	desc=rowsData[j][colOpt.field];   //û������Դ��ȡ����
				if((colOpt.field=="82")&&($.trim(desc)=="")){
					$.messager.alert("��ʾ","��ʾ���Ĳ���Ϊ�գ�")
					return false;
				}
				var ID=rowsData[j].ID;
				if(ID==null){
					ID="";
				}
				var value=colOpt.field
				if(value=="catalog"){    			  //���ϼ���Ŀ¼�ֵ�����⴦��
					var DrugLibaryID=serverCall("web.DHCCKBRuleMaintain","DrugLibaryDataID",{"dicId":dicId});
					var array=DrugLibaryID.split("^")
					num=array[0];
					value=num;	
				}
				var tmp=ID +"^"+desc +"^"+ value +"^"+ dicId +"^"+ 0 ;
				dataList.push(tmp);
			}	
			
			
		}
		var mListData=dataList.join("$$");
		dataListAll.push(mListData);
	}
	var mListDataAll=dataListAll.join("@@");
	console.log(mListDataAll)
		//��������
	runClassMethod("web.DHCCKBRuleMaintain","saveAll",{"params":mListDataAll},function(jsonString){
		if (jsonString == 0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		$('#modelTable').datagrid('reload'); //���¼���	
		
	});
	///end 2020-04-13
}
///�ύ����
function submitModelRow()
{
	var Selected=$('#modelTable').datagrid('getSelected')
	if(Selected==null){
		$.messager.alert("��ʾ","��ѡ���¼");
		return;
	}
	
	runClassMethod("web.DHCCKBRuleMaintain","SubmitRule",{"GroupNo":Selected.GroupNo,"LoginInfo":LoginInfo},function(jsonstring){
		if(jsonstring=="-1"){
			$.messager.alert("��ʾ","ҩƷ���ơ�ͨ����(������)������Ϊ�գ�");
		}
		if(jsonstring=="-2"){
			$.messager.alert("��ʾ","��ʾ������Ϊ�գ�");
		}
		if(jsonstring.code=="success"){
			$.messager.alert("��ʾ","�ύ�ɹ���");
		}
		$('#modelTable').datagrid('reload');
	});
}
///ɾ��
function cancelModelRow()
{
	var Selected=$('#modelTable').datagrid('getSelected')
	if(Selected==null){
		$.messager.alert("��ʾ","��ѡ���¼");
		return;
	}
	
	runClassMethod("web.DHCCKBRuleMaintain","UpdSubFlag",{"GroupNo":Selected.GroupNo,"Flag":3},function(jsonstring){
		if(jsonstring!="0"){
			$.messager.alert("��ʾ","ɾ��ʧ�ܣ�");
		}
		$('#modelTable').datagrid('reload');
	});
}




/**
* @ͨ�õ���div��
* @param 	width 	 	|string 	|���
* @param 	height 	 	|string 	|�߶�
* @param 	code 	 	|string 	|�����ֵ�code
* @param 	adm 	 	|string 	|�����ID
* @param 	input 	 	|string 	|���
* @param 	emrType 	|string 	|������
* @param 	htmlType 	|string 	|html����
*						input
*						radio
*						checkbox  
*						tree
*						datagrid
* @author zhouxin
*/
function ruledivComponent(opt,callback){
	
		var option={
			width: 1000,
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
		$(document.body).append('<div id="win" class="winp" style="width:'+ option.width +';height:'+option.height+';border:1px solid #E6F1FA;background-color:#eee;"></div>') 
		var html='<div id="mydiv" class="hisui-layout" fit=true style="background-color:#eee;">'
		html=html+' <div data-options="region:\'center\',title:\'\',border:false,collapsible:false" style="background-color:#eee;height:'+option.height+'">';
		html=html+'<div id="divAttrTable" toolbar="#tableTb"></div>';
		html=html+'<div id="tableTb" style="margin:5px 5px 5px 5px;">';			//toolbar start
		html=html+'<div><span>����&nbsp;<input id="search" type="text" class="textbox" style="width:123px;"/></span>';
		html=html+'<span style="margin-left:1px;"><a href="#" class="hisui-linkbutton"  iconCls="icon-search" plain="true" id="serchtbdt" >��ѯ</a></span>'
		html=html+'<span style="margin-left:1px;"><a href="#" class="hisui-linkbutton"  iconCls="icon-add" plain="true" id="add" >������</a></span>';
		html=html+'<span style="margin-left:1px;"><a href="#" class="hisui-linkbutton"  iconCls="icon-add" plain="true" id="addDataSource" >��������Դ</a></span></div>'
		html=html+'<div style="margin-top:5px" >'						//button start
		html=html+'	<span><a id="symbol1" style="margin-left:-10px;" href="#" class="hisui-linkbutton"  plain="true" name="!" >����</a>'
		html=html+'		  <a id="symbol2" style="margin-left:-20px;" href="#" class="hisui-linkbutton" plain="true" name=">" >����</a>'
		html=html+'		  <a id="symbol3" style="margin-left:-20px;" href="#" class="hisui-linkbutton"  plain="true" name=">=" >���ڻ����</a>'
		html=html+'		  <a id="symbol4" style="margin-left:-20px;" href="#" class="hisui-linkbutton"  plain="true" name="<" >С��</a>'
		html=html+'		  <a id="symbol5" style="margin-left:-20px;" href="#" class="hisui-linkbutton"  plain="true" name="<=" >С�ڻ����</a>'
		html=html+'		  <a id="symbol6" style="margin-left:-20px;" href="#" class="hisui-linkbutton"  plain="true" name="~" >Between</a>'
		html=html+'		  <a id="symbol7" style="margin-left:-20px;" href="#" class="hisui-linkbutton"  plain="true" name="!=" >������</a>'
		html=html+' </span>'
		html=html+'</div>'    //button end
		html=html+'</div>';														//toolbar end
		html=html+'</div>';
		html=html+' <div data-options="region:\'south\',title:\'\',border:false,collapsible:false" style="text-align:center;background-color:#eee;">';
		html=html+'		<a href="#" class="hisui-linkbutton" id="saveDivWinBTN"  style="width:60px" >����</a>';
		html=html+'		<a href="#" class="hisui-linkbutton"  id="removeDivWinBTN" style="width:60px"  >�ر�</a>';
		html=html+'</div>';
		html=html+'</div>';
	
		$("#win").append(html);
		
		if (option.htmlType == "datagrid"){
			// ����columns
			var columns=[[  
					{field:'ID',title:'RowId',hidden:true},
					{field:'Alias',title:'����',width:300,align:'center'},
					{field:'CDCode',title:'����',width:200,align:'center'},
					{field:'CDDesc',title:'����',width:200,align:'center'},
					{field:'CDParrefDesc',title:'���ڵ�',width:100,align:'center'}
					/*{field:'CDTypeDesc',title:'����',width:300,align:'center'},
					{field:'CDLinkDr',title:'����ID',width:300,align:'center'}		 */			
				 ]]
			var gridcolumns=option.Incolumns==""?columns:option.Incolumns;
			
			var options={	
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
		 		onClickRow:function(rowIndex,rowData){ 
		 			if(option.Incolumns==""){
			 			callback(rowData);
			 		}  
				}, 
				onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
		             var fileds=$('#divAttrTable').datagrid('getColumnFields');
						var params=fileds.join("&&");
						runClassMethod("web.DHCCKBDicLinkAttr","getEditors",{"FiledList":params},function(jsonString){
							
							for(var j=0;j<jsonString.length;j++)
							{
								if(jsonString[j].editors=="combobox"){
									var e = $("#divAttrTable").datagrid('getColumnOption',jsonString[j].Filed);
									e.editor = {
										type:'combobox',
									  	options:{
										valueField:'value',
										textField:'text',
										mode:'remote',
										url:$URL+'?ClassName=web.DHCCKBRuleMaintain&MethodName=GetDataCombo&DataSource='+jsonString[j].source+'&filed='+jsonString[j].Filed,
										onSelect:function(option) {
											
										} 
									 }
								  }
								}	
							}
							if (editDRow != ""||editDRow == 0) { 
		                		$("#divAttrTable").datagrid('endEdit', editDRow); 
		            		} 
		            		$("#divAttrTable").datagrid('beginEdit', rowIndex);
				            
				            editDRow = rowIndex; 
		            		//$("#win").remove();
						})
		        }				  
			}
			var id=option.filed;
			var input=option.input;
			//var uniturl = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicList&params=^^";
			var uniturl =LINK_CSP+'?ClassName=web.DHCCKBRuleMaintain&MethodName=QueryDicByID'   //+"&parDesc="+encodeURIComponent(input)
			new ListComponent('divAttrTable', gridcolumns, uniturl, options).Init();
			
		}
		else if (option.htmlType == "tree"){	
				
			var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;

			var options = {
				multiple: true,
				lines:true,
				animate:true,
		        onClick:function(node, checked){		       
			        var isLeaf = $("#divAttrTable").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
			        if (isLeaf){
				        //$(option.tarobj).val(itmText); 		
						//$(ed.target).val(itmID);							
						$("#win").remove();	
			        }else{
				    	//$("#divAttrTable").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
				    }
				    $(option.tarobj).val(node.text);
				    callback(node);
			    },
			    onExpand:function(node, checked){
					var childNode = $("#divAttrTable").tree('getChildren',node.target)[0];  /// ��ǰ�ڵ���ӽڵ�
			        var isLeaf = $("#divAttrTable").tree('isLeaf',childNode.target);        /// �Ƿ���Ҷ�ӽڵ�
			        if (isLeaf){
				        
			        }
				}
			};		
			new CusTreeUX("divAttrTable", url, options).Init();			
		}		
		$("#win").show();
		$.parser.parse($("#win"));
		var tleft = "";
		if((option.tarobj.offset().left+1000)>$(document.body).height()){
			tleft= 1000 - (document.body.offsetWidth - option.tarobj.offset().left);
		}
		//var $left=option.tarobj.offset().left<option.width?option.tarobj.offset().left:(document.body.offsetWidth/2-option.tarobj.offset().left+option.width);
		var $left=option.tarobj.offset().left<option.width?option.tarobj.offset().left:(option.tarobj.offset().left-(document.body.offsetWidth/2-option.width));
		
		$("#win").css("left",100);
		//$("#win").css("left",option.tarobj.offset().left - tleft);		
		var winTop=option.tarobj.offset().top+ option.tarobj.outerHeight();		// win���붥����λ��
		var winHieght=option.height;											// win����Ŀ��
		var $top=($(window).height()-winTop)>winHieght?winTop:winTop-winHieght-30;
		$("#win").css("top",$top);		
		//$("#win").css("top",option.tarobj.offset().top+ option.tarobj.outerHeight());
		
		$("#divTable").find("td").children().eq(0).focus();
		$("#saveDivWinBTN").on('click',function(){
			
			if (option.htmlType == "textarea"){
				$(option.tarobj).val($("#divTable").val());
			}	
			if(editDRow>="0"){
				$("#divAttrTable").datagrid('endEdit', editDRow);
			}
			if ((option.htmlType == "datagrid")&&(option.Incolumns!="")){	
				console.log(1)
				if(option.Incolumns==""){return}
				var ed=$("#modelTable").datagrid('getEditor',{index:editRow, field:field});
				if(editDRow>="0"){
					$("#divAttrTable").datagrid('endEdit', editDRow);
				}
				var selItem=$("#divAttrTable").datagrid('getChanges')
				if(selItem.length<=0){
					$("#win").remove();
					$.messager.alert("��ʾ","û�д���������!");
					return;
				}
				var fileds=$('#divAttrTable').datagrid('getColumnFields');
				//var params=fileds.join("&&");
			    var selList="";
			    var selArray=[];
			    if($(ed.target).val()!=""){selArray.push($(ed.target).val())}
				for (var i=0;i<selItem.length;i++){
					for(var j=0;j<fileds.length;j++){
						if(fileds[j].indexOf("Id")>=0){continue;}
						if(selList==""){selList=selItem[i][fileds[j]]}
						else{selList=selList +selItem[i][fileds[j]]}
					}
					selArray.push(selList);
				}
				var inputlist=selArray.join(",")
				$(ed.target).val(inputlist)
				
			}
			$("#win").remove();
		})
	 	$("#add").on('click',function(){
			insertRow();
		});
		$("#addDataSource").on('click',function(){
			insertDataRow();
		});
		$("#removeDivWinBTN").on('click',function(){
				$("#win").remove();
		});
		
		// ��ѯ
		$("#serchtbdt").on('click',function(){
				var searchDesc = $.trim($("#search").val());
				$("#divAttrTable").datagrid("load",{"id":id,"parDesc":searchDesc}); 
		});
		$('#search').bind('keypress',function(event){
	        if(event.keyCode == "13")    
	        {
	            var searchDesc = $.trim($("#search").val());
				$("#divAttrTable").datagrid("load",{"id":id,"parDesc":searchDesc}); 
	        }
    	});
		///��ť����
		$("a[id^='symbo']").on('click',function(){
			var stmbol=$(this).attr('name');
			SymbolClick(stmbol)
		});
		
		
		$(document).keyup(function(event){
			
			switch(event.keyCode) {
				case 27:
					$("#win").remove();
				case 96:
					$("#win").remove();
			}
		});
}
function SymbolClick(stmbol)
{
	var ed=$("#modelTable").datagrid('getEditor',{index:editRow, field:field});
	$(ed.target).insertAtCaret(stmbol);
	//
	//var desc=$(ed.target).val();
	//$(ed.target).val(stmbol+desc);
}
function insertRow()
{
	var fileds=$('#divAttrTable').datagrid('getColumnFields');
	var params=fileds.join("&&");
	runClassMethod("web.DHCCKBDicLinkAttr","getEditors",{"FiledList":params},function(jsonString){
		for(var j=0;j<jsonString.length;j++)
		{
			if(jsonString[j].editors=="combobox"){
				var e = $("#divAttrTable").datagrid('getColumnOption',jsonString[j].Filed);
				e.editor = {
					type:'combobox',
				  	options:{
					valueField:'value',
					textField:'text',
					mode:'remote',
					url:$URL+'?ClassName=web.DHCCKBRuleMaintain&MethodName=GetDataCombo&DataSource='+jsonString[j].source+'&filed='+jsonString[j].Filed,
					onSelect:function(option) {
						
					} 
				 }
			  }
			}	
		}
		saveDataSour="" //��ʾΪ�����а�ť�ı�ʶ
		if(editDRow>="0"){
			$("#divAttrTable").datagrid('endEdit', editDRow);		//�����༭������֮ǰ�༭����
		}
		$("#divAttrTable").datagrid('insertRow', {
			index: 0, // ������0��ʼ����
			row: {}
		});
		
		$("#divAttrTable").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
		editDRow=0;
	})
}

///�������ݵ���Ӧ������Դ
function insertDataRow(){
	var searchDesc = $("#search").val();
	if (searchDesc=="")
	{
		$.messager.alert("��ʾ","û�д��������");
		$("#win").remove();
		return;
	}
	var params="^^"+searchDesc+"^"+field;
	//��������
	runClassMethod("web.DHCCKBRuleMaintain","saveOrUpdateData",{"params":params,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		if (jsonString == 0){
			$.messager.popover({msg: '����ɹ�����',type:'success',timeout: 1000});
		}else if(jsonString==-1){
			$.messager.alert('��ʾ','�������!','warning');
		}else if(jsonString==-2){
			$.messager.alert('��ʾ','��������!','warning');
		}else{
			$.messager.alert('��ʾ','����ʧ��!','warning');
		}
		$('#divAttrTable').datagrid('reload'); //���¼���	
	});
	
	
	/**	var fileds=$('#divAttrTable').datagrid('getColumnFields');
	var params=fileds.join("&&");
	runClassMethod("web.DHCCKBDicLinkAttr","getEditors",{"FiledList":params},function(jsonString){
		for(var j=0;j<jsonString.length;j++)
		{
			if(jsonString[j].editors=="combobox"){
				$.messager.alert("��ʾ","�������ӵ�����Դ");
				$("#win").remove();
				return;
			}
			if(jsonString[j].editors!="combobox"){
				var e = $("#divAttrTable").datagrid('getColumnOption',jsonString[j].Filed);
				e.editor = {
					type:'text',
				  	options:{
					valueField:'value',
					textField:'text',
					mode:'remote',
					required: true, //���ñ༭��������
				 }
			  }
			}	
		}
		saveDataSour=1  //��ʾΪ��������Դ��ť�ı�ʶ
		if(editDRow>="0"){
			$("#divAttrTable").datagrid('endEdit', editPRow);		//�����༭������֮ǰ�༭����
		}
		$("#divAttrTable").datagrid('insertRow', {
			index: 0, // ������0��ʼ����
			row: {}
		});
		
		$("#divAttrTable").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
		editPRow=0;
	})	*/
}
