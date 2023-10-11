/**
	sufan
	2020-04-23
	����ά��
*/
var editRow = "0",editTRow = "0",editRuleRow="0",editWinRow="0"; 
var TempId="",field="";
var selArray = [{"value":"0","text":'�ѱ���'}, {"value":"1","text":'���ύ'},{"value":"2","text":'ȫ��'}];
$(function(){ 
	
	initButton();			//��ʼ����ť
	initcombobox();			//��ʼ������ά������
	initDrugList();			//��ʼ��ҩƷ�б�
	//initRuleList();		//��ʼ�������б�

})
///��ʼ����ť
function initButton()
{
	$("#insert").bind("click",InsertSouRow);	// ��������
	$("#save").bind("click",SaveRow);		// ����
	$('#desc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			Query();
		}
	});
	$("#search").bind("click",Query);			// ����
	
	$("#ruleins").bind("click",InsRuleRow)   	// ���ӹ���
	
	$("#rulesave").bind("click",SaveRuleRow)   	// ���ӹ���
	
	$("#rulesubmit").bind("click",subRuleRow)   // �ύ����
	
	$("#rulecan").bind("click",cancelRuleRow)   // ɾ������
	
	$("#rulecopy").bind("click",copyRuleRow)    // ���ƹ���
	
	$("#editprop").bind("click",editProp)       // ֪ʶά��
	
	$("#multiplex").bind("click",multiPlex) 	// ����
	
	$("#predictText").bind("click",predictText) ;	// �ı����
	
	$("#diagmatch").bind("click",matchdiag) ;
		
}
function initcombobox(){
	
	///ģ������
	$('#modelTree').combobox({
    	url:LINK_CSP+'?ClassName=web.DHCCKBDrugRuleMaintain&MethodName=ListModelTree',
    	lines:true,
		animate:true,
		onSelect: function(rec){
			//$('#drugList').datagrid('load',{params:rec.text});
			$("#model").combobox('setValue',"");
			TempId="";
			var unitUrl = $URL+"?ClassName=web.DHCCKBDrugRuleMaintain&MethodName=ListModel&TypeId="+rec.value;
			$("#model").combobox('reload',unitUrl);
			$('#drugList').datagrid('load',{params:rec.text});
	    },
	    onLoadSuccess:function(data){
		    $('#modelTree').combobox('setValue',data[0].value);
		}
	});
	///ģ��
	$('#model').combobox({
    	lines:true,
		animate:true,
		onSelect: function(option){
			TempId=option.value;
			var selitem=$('#drugList').datagrid('getSelected');
			if(selitem==null){return;}
			initRuleList();
	    },
	    onLoadSuccess:function(){
		    
		}
	});
	///��������
	$('#modellist').combobox({
		data:selArray,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option){
			if(TempId==""){
				$.messager.alert('��ʾ','����ѡ��ģ�壡')
				return;
			}
			var DrugId=$('#drugList').datagrid('getSelected').DrugId;
			var params=option.value+"^"+DrugId;
			var url=$URL+"?ClassName=web.DHCCKBDrugRuleMaintain&MethodName=ListModelData&parent="+TempId+"&params="+params;
			$('#ruleList').datagrid('options').url=url;
        	$("#ruleList").datagrid('reload');  
		},
		onLoadSuccess:function(){
		    $('#modellist').combobox('setValue',2);
		}
	})
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
			var url=$URL+"?ClassName=web.DHCCKBRuleMaintain&MethodName=ListModelDataNew&params="+option.value;
			$('#drugList').datagrid('options').url=encodeURI(url)
        	$("#drugList").datagrid('reload');  
		} 
	})
}
///��ʼ��ҩƷ�б�
function initDrugList()
{
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'DrugId',title:'DrugId',width:100,align:'center',hidden:'true'},
		{field:'RuleFlag',title:'',width:30,align:'center'},
		{field:'DrugDesc',title:'ҩƷ����',width:220,align:'center',editor:textEditor},
	]];
	
	///  ����datagrid  
	var option = {
		rownumbers : true,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#drugList").datagrid('endEdit', editRow); 
            } 
            $("#drugList").datagrid('beginEdit', rowIndex); 
            
            var editors = $('#drugList').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 ʧȥ����رձ༭��                
            for (var i = 0; i < editors.length; i++)   
            {  
                var e = editors[i]; 
              	$(e.target).bind("blur",function()
              	  {  
                    $("#drugList").datagrid('endEdit', rowIndex);
                  });   
                  
            } 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){	
        	if(TempId==""){
	        	$.messager.alert('��ʾ',"����ѡ��ģ�壡")
	        	return;
	        }
        	initRuleList();
	    }
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBDrugRuleMaintain&MethodName=QueryDrugList"  //&params="+"&UserInfo="+LoginInfo;
	new ListComponent('drugList', columns, uniturl, option).Init(); 
}
///������
function InsertSouRow()
{
	if(editRow>="0"){
		$("#drugList").datagrid('endEdit', editRow);		//�����༭������֮ǰ�༭����
	}
	$("#drugList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {DrugId:'', DrugDesc:''} ,
		row: {}
	});
	$("#drugList").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	editRow=0;
}
///����
function SaveRow()
{
	if(editRow>="0"){
		$("#drugList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#drugList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var Temp=$("#modelTree").combobox('getText');
	var parref=serverCall("web.DHCCKBDrugRuleMaintain","getDictionId",{"Temp":Temp});
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].DrugDesc==""){
			$.messager.alert("��ʾ","��������Ϊ��!"); 
			return false;
		}
		if(parref==""){
			$.messager.alert("��ʾ","��ѡ��ģ�����ͣ�"); 
			return false;
		}
		var tmp=$g(rowsData[i].DrugId) +"^"+ $g(rowsData[i].DrugDesc) +"^"+ $g(rowsData[i].DrugDesc) +"^"+ parref;
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";

	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		
		if (jsonString >= 0){
			$.messager.popover({msg: '����ɹ�����',type:'success',timeout: 1000});
		}else if(jsonString == -98){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');
			
		}else if(jsonString == -99){
			$.messager.alert('��ʾ','����ʧ��,�����ظ���','warning');

		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}		
		$('#drugList').datagrid('reload'); //���¼���
	});
}
///��ѯ
function Query()
{
	var Temp=$("#modelTree").combobox('getText');
	var Desc=$.trim($("#desc").val());
	var params=Temp +"^"+ Desc; // 
	$('#drugList').datagrid('load',{params:params,UserInfo:LoginInfo});
}
///��ʼ�������б�
function initRuleList()
{
	
	runClassMethod("web.DHCCKBDrugRuleMaintain","ListModelDataGrid",{"dicId":TempId},function(data){
	
		var json= eval('(' + data + ')');
		
		var columns=[json];
		///  ����datagrid  
		var option = {
			rownumbers : true,
			//singleSelect : true,  //xww 2021-08-17 �����ѡ
			onClickRow:function(rowIndex,rowData){
 		    if (editRow != ""||editRow == 0) {    //wangxuejian 2021-05-21  �رձ༭�� 
                $("#ruleList").datagrid('endEdit', editRow); 
             } 
 		    }, 
		    onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
				var seldrug=$("#drugList").datagrid("getSelected");
				var Temp=$("#modelTree").combobox('getText');
				var Model = $("#model").combobox('getText');
				if(Temp=="��ҩģ��"){
					var e = $("#ruleList").datagrid('getColumnOption', '81224');
					e.editor = {};
					if(Model.indexOf("ָ��")>="0"){
						
					}else{
						var e = $("#ruleList").datagrid('getColumnOption', 'catalog');
						e.editor = {};
					}
				}else if(Temp.indexOf("ָ��")>="0"){
					var e = $("#ruleList").datagrid('getColumnOption', '81224');
					e.editor = {};
				}else if(Temp=="ͨ����ģ��"){
					var e = $("#ruleList").datagrid('getColumnOption', '74532');
					e.editor = {};
					if(Model.indexOf("ָ��")>="0"){
						
					}else{
						var e = $("#ruleList").datagrid('getColumnOption', 'catalog');
						e.editor = {};
						}
				}else{
					var e = $("#ruleList").datagrid('getColumnOption', '81842');
					e.editor = {};
					var e = $("#ruleList").datagrid('getColumnOption', 'catalog');
					e.editor = {};
				}
	            CommonRowClick(rowIndex,rowData,"#ruleList"); //�༭��
	            var editors = $('#ruleList').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 ʧȥ����رձ༭��  
	             for (var i = 0; i < editors.length; i++)   
                {  
                   var e = editors[i]; 
              	   $(e.target).bind("blur",function()
              	   {  
                    //  $("#ruleList").datagrid('endEdit', rowIndex);
                    });   
                  
                  } 
                  editRow = rowIndex;
           		dataGridBindEnterEvent(rowIndex);				//���������������ʾ�ֵ�datagrid
	        }
		};
		//alert(3)
		var DrugId=$('#drugList').datagrid('getSelected').DrugId;
		var params=$("#modellist").combobox('getValue') +"^"+ DrugId +"^"+ $("#modelTree").combobox('getValue');
		console.log(params)
		var uniturl = $URL+"?ClassName=web.DHCCKBDrugRuleMaintain&MethodName=ListModelData&parent="+TempId+"&params="+params;
		new ListComponent('ruleList', columns, uniturl, option).Init();
			
	},"text")
}
///����������
function InsRuleRow()
{
	
	var selTemp=$("#model").combobox('getValue');
	if(selTemp==""){
		$.messager.alert('��ʾ',"����ѡ��ģ�壡");
		return;
	}
	var DrugLibaryID=serverCall("web.DHCCKBRuleMaintain","DrugLibaryDataID",{"dicId":TempId});  		//��ȡģ��󶨵�Ŀ¼��ID������
	var array=DrugLibaryID.split("^")
	var ID=[array[0]];		//Ŀ¼ID��73��
	num=array[0];
	var catalog=array[1];	//Ŀ¼��������Ӧ֢��
	var e = $("#ruleList").datagrid('getColumnOption', 'catalog');
	///����ģ�壬��ȡ��ͬ���͵�ҽ��������
	var Temp=$("#modelTree").combobox('getText');
	var Model = $("#model").combobox('getText');
	///������ҩָ��������
	if(Model.indexOf("ָ��")>="0"){
		
	}else{
		e.editor = {};
	}
	//ȡ����ҩ������
	var seldrug=$("#drugList").datagrid("getSelected");
	if((Temp=="��ҩģ��")){
		if(Model.indexOf("ָ��")>="0"){
			var e = $("#ruleList").datagrid('getColumnOption', '81224');
			e.editor = {};
			commonAddRow({'datagrid':'#ruleList',value:{"81224":seldrug.DrugDesc,"81224Id":seldrug.DrugId,"74698":"Y","74698Id":"26852"}})
		}else{
			var e = $("#ruleList").datagrid('getColumnOption', '81224');
			e.editor = {};
			if(Model.indexOf("�������")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81224":seldrug.DrugDesc,"81224Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"����","64Id":"3955"}})
			}else if(Model.indexOf("�໥����")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81224":seldrug.DrugDesc,"81224Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"���","64Id":"4285"}})
			}else if(Model.indexOf("��ý��Һ")>="0"){
				//ȡҩƷ�Ƿ�Ϊ������򶳸ɷ����
				var IsPowderFlag=serverCall("web.DHCCKBRuleMaintain","IsPowderInjection",{'DrugId':seldrug.DrugId});
				if (IsPowderFlag==="Y"){
					//�ǵĻ�����ϡ�ͺ��ҩĬ��ΪY
					commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81224":seldrug.DrugDesc,"81224Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","81":"��ʾ","81Id":"139","130544":"Y","130544Id":"26852"}})
				}else {
					commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81224":seldrug.DrugDesc,"81224Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","81":"��ʾ","81Id":"139"}})
					}
			
			
			}
			else{
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81224":seldrug.DrugDesc,"81224Id":seldrug.DrugId,"74698":"Y","74698Id":"26852"}})
			}
		}
	}else{
		if((Model.indexOf("ָ��")>="0")&&(Model.indexOf("ָ��(ͨ����)")<"0")){
			var e = $("#ruleList").datagrid('getColumnOption', '81842');
			e.editor = {};
			commonAddRow({'datagrid':'#ruleList',value:{"81842":seldrug.DrugDesc,"81842Id":seldrug.DrugId,"74698":"Y","74698Id":"26852"}})	
					
			
		}
		if((Temp=="ͨ����ģ��")){
			var e = $("#ruleList").datagrid('getColumnOption', '74532');
			e.editor = {};
			if(Model.indexOf("�������")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"74532":seldrug.DrugDesc,"74532Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"����","64Id":"3955"}})

			}else if(Model.indexOf("�໥����")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"74532":seldrug.DrugDesc,"74532Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"���","64Id":"4285"}})
			}
			else if(Model.indexOf("��ý��Һ")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"74532":seldrug.DrugDesc,"74532Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","81":"��ʾ","81Id":"139"}})
			}
			else{
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"74532":seldrug.DrugDesc,"74532Id":seldrug.DrugId,"74698":"Y","74698Id":"26852"}})
			}
		}else{
			var e = $("#ruleList").datagrid('getColumnOption', '81842');
			e.editor = {};
			if(Model.indexOf("�������")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81842":seldrug.DrugDesc,"81842Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"����","64Id":"3955"}})

			}else if(Model.indexOf("�໥����")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81842":seldrug.DrugDesc,"81842Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"���","64Id":"4285"}})
			}
			else if(Model.indexOf("��ý��Һ")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81842":seldrug.DrugDesc,"81842Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","81":"��ʾ","81Id":"139"}})
			}
			else{
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81842":seldrug.DrugDesc,"74532Id":seldrug.DrugId,"74698":"Y","74698Id":"26852"}})
			}
		}
	}
	
	dataGridBindEnterEvent(0);
		
	
}
//���������������ʾ�ֵ�datagrid
function dataGridBindEnterEvent(index){
	
	editRuleRow=index;
	var editors = $('#ruleList').datagrid('getEditors',index);
	for(var i=0;i<editors.length;i++){
		var workEditor = editors[i];
		editors[i].target.attr("field",editors[i].field);
		editors[i].target.mousedown(function(e){
				var DataDesc="",DataID=""
				field=$(this).attr("field");	 /// ģ����֧��һ������ά�����,���ڶ��ά��������,��ʽ��90975-mul qnp 2022-09-22			
				var fieldId=field+"Id";
				var ed=$("#ruleList").datagrid('getEditor',{index:index, field:field});		 
				var input = $(ed.target).val();															//����
				var isDataSource=serverCall("web.DHCCKBRuleMaintain","isDataSource",{'field':((field.indexOf("-mul")!=-1)?field.split("-mul")[0]:field)}); 	//�Ƿ���Ҫ��������
				
				
				if((isDataSource==0)){
					var Array=[],dgObj={},Incolumns=[];
					var textEditor={
						type: 'text',//���ñ༭��ʽ
						options: {
							required: true //���ñ༭��������
						}
					}
					runClassMethod("web.DHCCKBRuleMaintain","QueryColumns",{"AttrcodeId":((field.indexOf("-mul")!=-1)?field.split("-mul")[0]:field),"DicCode":""},function(jsonString){	
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
				 			}		//for  end
							Incolumns.push(Array);
						}		//if end
						ruledivComponent({
								  tarobj:$(ed.target),
								  filed:field,
								  input:input,
								  htmlType:'datagrid',
								  height:'310',
								  Incolumns:Incolumns,
								  url:LINK_CSP+'?ClassName=web.DHCCKBRuleMaintain&MethodName=QueryDicByID&id='+((field.indexOf("-mul")!=-1)?field.split("-mul")[0]:field)+"&parDesc="+encodeURIComponent(input),
								  columns:[[
								  	{field:'DicID',hidden:true},
								  	{field:'DicDesc',title:'����',width:60},
								  
								  ]] 
								},function(rowData){
									var ed=$("#ruleList").datagrid('getEditor',{index:index, field:field});	
									var IdEd=$("#ruleList").datagrid('getEditor',{index:index,field:field+"Id"});
									if(field=="catalog"){				//Ŀ¼
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="83"){				//��������
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="81"){				//������
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="89"){				//�Ա�
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="65"){				//�Ƿ��״θ�ҩ
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="64"){				//�������
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="74698"){			//��Ϣ��ʾ���
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="40"){				//����
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else{
										var input = $(ed.target).val();					//����
										var fieldIdinput="";
										if(input=="")
										{
											DataDesc=rowData.DicDesc;
										}
										else{
											DataDesc=input+","+rowData.DicDesc;   		//����
										}
										$(ed.target).val(DataDesc);
										if(DataID=="")
										{
											if((fieldIdinput=="")&&(input=="")){
												DataID=rowData.DicID;
											}
											else{
												DataID=fieldIdinput+","+rowData.DicID; 	//Id
											}
										}
										else{
											DataID=DataID+","+rowData.DicID;
										}
										$(IdEd.target).val(DataID);
									}
						})
					},'json','false')	
				}
			
		});
	}
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
			width: 900,
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
		html=html+'<div><span>����&nbsp;<input id="searchwin" type="text" class="textbox" style="width:123px;"/></span>';
		html=html+'<span style="margin-left:1px;"><a href="#" class="hisui-linkbutton"  iconCls="icon-search" plain="true" id="serchtbdt" >��ѯ</a></span>'
		html=html+'<span style="margin-left:1px;"><a href="#" class="hisui-linkbutton"  iconCls="icon-add" plain="true" id="add" >������</a></span>';
		html=html+'<span id="inssou" style="margin-left:1px;display:none;"><a href="#" class="hisui-linkbutton"  iconCls="icon-add" plain="true" id="addDataSource" >��������Դ</a></span>'
		//html=html+'<div style="margin-top:5px" >'						//button start
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
		
		/**������������Դ��ť����ʾ**/
		var coltitle = serverCall("web.DHCCKBDrugRuleMaintain","GetColFieldTitle",{"filed":((option.filed.indexOf("-mul")!=-1)?option.filed.split("-mul")[0]:option.filed)});
		if(coltitle.indexOf("����")>=0){
			$("#inssou").show();
		}
		if (option.htmlType == "datagrid"){
			// ����columns
			var columns=[[  
					{field:'DicID',title:'RowId',hidden:true},
					{field:'Alias',title:'����',width:450,align:'center'},
					{field:'DicCode',title:'����',width:150,align:'center'},
					{field:'DicDesc',title:'����',width:300,align:'center'},
					{field:'ParrefDesc',title:'���ڵ�',width:160,align:'center'}
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
		 			//if(option.Incolumns==""){
			 			callback(rowData);
			 		//}  
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
											
										},
										formatter: function(row){
											var opts = $(this).combobox('options');
											return tomodify(row[opts.textField]);
										}
									 }
								  }
								}	
							}
							if (editWinRow != ""||editWinRow == 0) { 
		                		$("#divAttrTable").datagrid('endEdit', editWinRow); 
		            		} 
		            		$("#divAttrTable").datagrid('beginEdit', rowIndex);
				            
				            editWinRow = rowIndex; 
		            		//$("#win").remove();
						})
		        }				  
			}
			var id=((option.filed.indexOf("-mul")!=-1)?option.filed.split("-mul")[0]:option.filed)
			var input=option.input;
			var uniturl =$URL+'?ClassName=web.DHCCKBDrugRuleMaintain&MethodName=QueryDicList'   //+"&parDesc="+encodeURIComponent(input)
			new ListComponent('divAttrTable', gridcolumns, uniturl, options).Init();	
		}	
		$("#win").show();
		$.parser.parse($("#win"));
		var tleft = "";
		if((option.tarobj.offset().left+500)>$(document.body).height()){
			tleft= 500 - (document.body.offsetWidth - option.tarobj.offset().left);
		}
		//var $left=option.tarobj.offset().left<option.width?option.tarobj.offset().left:(option.tarobj.offset().left-(document.body.offsetWidth/2-option.width));
		var $left=option.tarobj.offset().left<option.width?option.tarobj.offset().left:(option.tarobj.offset().left-(document.body.offsetWidth/2-option.width)); // ������౻�ڸǵ����
		if (document.body.offsetWidth-option.tarobj.offset().left<option.width){	// �����Ҳ౻�ڸǵ����
			$left=document.body.offsetWidth-option.width;
		}		
		$("#win").css("left",$left);
		
		var winTop=option.tarobj.offset().top+ option.tarobj.outerHeight();		// win���붥����λ��
		var winHieght=option.height;											// win����Ŀ��
		var $top=($(window).height()-winTop)>winHieght?winTop:winTop-winHieght-30;
		$("#win").css("top",$top);		
		$("#divTable").find("td").children().eq(0).focus();
		$("#saveDivWinBTN").on('click',function(){
			if(editWinRow>="0"){
				$("#divAttrTable").datagrid('endEdit', editWinRow);
			}
			if ((option.htmlType == "datagrid")&&(option.Incolumns!="")){	
				if(option.Incolumns==""){return}
				var ed=$("#ruleList").datagrid('getEditor',{index:editRuleRow, field:field});
				if(editWinRow>="0"){
					$("#divAttrTable").datagrid('endEdit', editWinRow);
				}
				var selItem=$("#divAttrTable").datagrid('getChanges')
				if(selItem.length<=0){
					$("#win").remove();
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
			var searchDesc = $.trim($("#searchwin").val());
			$("#divAttrTable").datagrid("load",{"id":id,"parDesc":searchDesc}); 
		});
		///�س���ѯ
		$('#searchwin').bind('keypress',function(event){
	        if(event.keyCode == "13")    
	        {
	            var searchDesc = $.trim($("#searchwin").val());
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
///���Ų���
function SymbolClick(stmbol)
{
	var ed=$("#ruleList").datagrid('getEditor',{index:editRuleRow, field:field});
	$(ed.target).insertAtCaret(stmbol);
}
///������
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
						
					},
					formatter: function(row){
						var opts = $(this).combobox('options');
						return tomodify(row[opts.textField]);
					}
				 }
			  }
			}	
		}
		saveDataSour="" //��ʾΪ�����а�ť�ı�ʶ
		if(editWinRow>="0"){
			$("#divAttrTable").datagrid('endEdit', editWinRow);		//�����༭������֮ǰ�༭����
		}
		$("#divAttrTable").datagrid('insertRow', {
			index: 0, // ������0��ʼ����
			row: {}
		});
		
		$("#divAttrTable").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
		editWinRow=0;
	})
}

///�������ݵ���Ӧ������Դ
function insertDataRow(){
	var searchDesc = $("#searchwin").val();
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
}
///�������
function SaveRuleRow()
{
	if(!endEditing("#ruleList")){
		$.messager.alert("��ʾ","��༭��������!");
		return;
	}
	//2020-04-13 һ���Ա������
	var rowsData = $("#ruleList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var opts = $('#ruleList').datagrid('getColumnFields');
	var dataListAll = [];
	for(var j=0;j<rowsData.length;j++){
		var dataList = [];
		for(var i=0;i<opts.length;i++){
			var colOpt=$('#ruleList').datagrid('getColumnOption',opts[i])
			if (colOpt.field == "ShowFlag"){	// qunianpeng 2020-04-30 ����״̬��
				continue;	
			}
			var	catId = rowsData[j][colOpt.field]
			if((colOpt.field=="catalogId")&&($.trim(catId)=="")){
					$.messager.alert("��ʾ","��ҩָ������Ϊ�գ�")
					return false;
			}
			if(colOpt.hidden===false){
				var	desc=rowsData[j][colOpt.field];   //û������Դ��ȡ����
				if((colOpt.field=="82")&&($.trim(desc)=="")){
					$.messager.alert("��ʾ","��ʾ��Ϣ����Ϊ�գ�")
					return false;
				}
				if((colOpt.field=="catalog")&&($.trim(desc)=="")){
					$.messager.alert("��ʾ","��ҩָ������Ϊ�գ�")
					return false;
				}
				var ID=rowsData[j].ID;
				if(ID==null){
					ID="";
				}
				var value=colOpt.field
				if(value=="catalog"){    			  //���ϼ���Ŀ¼�ֵ�����⴦��
					
					var DrugLibaryID=serverCall("web.DHCCKBRuleMaintain","DrugLibaryDataID",{"dicId":TempId});
					var array=DrugLibaryID.split("^")
					num=array[0];
					value=num;
					if((array[1]=="��ҩָ��")&&(ID=="")){
						value = rowsData[j][colOpt.field+"Id"];
					}
					if((array[1]=="��ҩָ��")&&(ID!="")){
						value = rowsData[j][colOpt.field+"Id"];
						console.log(value+"ok")
						value = serverCall("web.DHCCKBRuleMaintain","GetIdByDesc",{"LevDesc":value})
						console.log(value+"ok11")
					}
				}
				var tmp=ID +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ;
				
				dataList.push(tmp);
			}	
		}
		var mListData=dataList.join("$$");
		dataListAll.push(mListData);
	}
	var mListDataAll=dataListAll.join("@@");
	
		//��������
	runClassMethod("web.DHCCKBRuleMaintain","saveAll",{"params":mListDataAll},function(jsonString){
		if (jsonString == 0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		$('#ruleList').datagrid('reload'); //���¼���	
		
	});
	///end 2020-04-13
}
///�ύ����
function subRuleRow()
{
	/*var Selected=$('#ruleList').datagrid('getSelected')
	if(Selected==null){
		$.messager.alert("��ʾ","��ѡ���¼");
		return;
	}*/
	
	//xww 2021-08-17�����ύ
	var SelectParams = $("#ruleList").datagrid('getSelections');
	if(SelectParams.length==0)
	{
		$.messager.alert('��ʾ',"��ѡ���¼");
		return false;
	}
	var dataList = []
	for(var i=0;i<SelectParams.length;i++)
	{
		var tmp = SelectParams[i].GroupNo;
		dataList.push(tmp);
	}
	var AllGroupNo=dataList.join("&&");
	//runClassMethod("web.DHCCKBRule","SubmitRule",{"GroupNo":Selected.GroupNo,"LoginInfo":LoginInfo},function(jsonstring){
	runClassMethod("web.DHCCKBRule","SubmitAllRule",{"AllGroupNo":AllGroupNo,"LoginInfo":LoginInfo},function(jsonstring){	
		if(jsonstring.code=="-1"){
			$.messager.alert("��ʾ","ҩƷ���ơ�ͨ����(������)������Ϊ�գ�");
		}
		if(jsonstring.code=="-2"){
			$.messager.alert("��ʾ","��ʾ������Ϊ�գ�");
		}
		if(jsonstring.code=="success"){
			$.messager.alert("��ʾ","�ύ�ɹ���");
		}
		if(jsonstring.code=="err"){
			
			$.messager.alert("��ʾ","�ύʧ�ܣ�"+jsonstring.content);
		}
		$('#ruleList').datagrid('reload');
	});
}
///ɾ��
function cancelModelRow()
{
	var Selected=$('#ruleList').datagrid('getSelected')
	if(Selected==null){
		$.messager.alert("��ʾ","��ѡ���¼");
		return;
	}
	
	runClassMethod("web.DHCCKBRuleMaintain","UpdSubFlag",{"GroupNo":Selected.GroupNo,"Flag":3},function(jsonstring){
		if(jsonstring!="0"){
			$.messager.alert("��ʾ","ɾ��ʧ�ܣ�");
		}
		$('#ruleList').datagrid('reload');
	});
}
///ɾ��
function cancelRuleRow()
{
	var Selected=$('#ruleList').datagrid('getSelected')
	if(Selected==null){
		$.messager.alert("��ʾ","��ѡ���¼");
		return;
	}
	
	runClassMethod("web.DHCCKBRule","UpdSubFlag",{"GroupNo":Selected.GroupNo,"Flag":3,"rule":Selected.ruleId},function(jsonstring){
		if(jsonstring!="0"){
			$.messager.alert("��ʾ","ɾ��ʧ�ܣ�");
		}
		$('#ruleList').datagrid('reload');
	});
}
///���ƹ���
function copyRuleRow()
{
	/* $.messager.alert('��ʾ',"���ܴ����ƣ�")
	return; */
	var seltems=$('#ruleList').datagrid('getSelections')
	if(seltems==null){
		$.messager.alert("��ʾ","��ѡ���¼");
		return;
	}
	var Fieldopts = $('#ruleList').datagrid('getColumnFields');

	var dataListAll = [];
	for(var j=0;j<seltems.length;j++){
		var dataList = [];
		for(var i=0;i<Fieldopts.length;i++){
			var colOpt=$('#ruleList').datagrid('getColumnOption',Fieldopts[i])
			if (colOpt.field == "ShowFlag"){	// qunianpeng 2020-04-30 ����״̬��
				continue;	
			}
			if(colOpt.hidden===false){
				var	desc=seltems[j][colOpt.field];   //û������Դ��ȡ����
				var ID=""
				var value=colOpt.field
				if(value=="catalog"){    			  //���ϼ���Ŀ¼�ֵ�����⴦��
					var DrugLibaryID=serverCall("web.DHCCKBRuleMaintain","DrugLibaryDataID",{"dicId":TempId});
					var array=DrugLibaryID.split("^")
					num=array[0];
					value=num;	
					if(array[1]=="��ҩָ��"){
						value = seltems[j][colOpt.field+"Id"];
						console.log(value+"ok")
						value = serverCall("web.DHCCKBRuleMaintain","GetIdByDesc",{"LevDesc":value})
						console.log(value+"ok11")
					}
				}
				var tmp=ID +"^"+desc +"^"+ value +"^"+ TempId +"^"+ 0 ;
				dataList.push(tmp);
			}	
		}
		var mListData=dataList.join("$$");
		dataListAll.push(mListData);
	}
	var mListDataAll=dataListAll.join("@@");
	runClassMethod("web.DHCCKBRuleMaintain","saveAll",{"params":mListDataAll},function(jsonString){
		if (jsonString == 0){
			$.messager.popover({msg: '����ɹ�����',type:'success',timeout: 1000});
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		$('#ruleList').datagrid('reload'); //���¼���	
		
	});
}
///֪ʶά��
function editProp()
{
	var seltems=$('#drugList').datagrid('getSelected')
	if(seltems==null){
		$.messager.alert("��ʾ","��ѡ��ҩƷ�б�");
		return;
	}
	
	var DrugId = seltems.DrugId; 
	var dicParref = serverCall("web.DHCCKBDrugRuleMaintain","GetEntyId",{"DrugId":DrugId})
	var linkUrl="dhcckb.editprop.csp"

	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'?parref='+DrugId+'&dicParref='+dicParref+'"></iframe>';

	if($('#win').is(":visible")){
		$("#win").remove();
	}
	if($('#winmodel').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:'ʵ��֪ʶά��',
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		//maximized:true,
		maximizable:true,
		minimizable:false,		
		width:$(window).width()-50, //800,
		height:$(window).height()-50,//500
	});	

	$('#winmodel').html(openUrl);
	$('#winmodel').window('open');
}
///ͣ�����ݸ���
function multiPlex()
{
	var linkUrl="dhcckb.stopdata.csp"

	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'"></iframe>';
	if($('#win').is(":visible")){
		$("#win").remove();
	}
	if($('#winstop').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winstop"></div>');
	$('#winstop').window({
		title:'ͣ�����ݸ���',
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		//maximized:true,
		maximizable:true,
		minimizable:false,		
		width:$(window).width()-50, //800,
		height:$(window).height()-50,//500
	});	

	$('#winstop').html(openUrl);
	$('#winstop').window('open');
}
function tomodify(str)
{
	var str=str.replace("��","^")   //�滻Ϊ�ѹ���������ţ���ѧ������� "��";
	return str;
}
///����������֮��
window.onload = function(){
	setTimeout(function(){
		var Temptype=$("#modelTree").combobox('getText');
		var TemptypeId=$("#modelTree").combobox('getValue');
		//$('#drugList').datagrid('load',{params:Temptype});
		var unitUrl = $URL+"?ClassName=web.DHCCKBDrugRuleMaintain&MethodName=ListModel&TypeId="+TemptypeId;
		$("#model").combobox('reload',unitUrl);
	},400)
}
///�ı����
function predictText(){
	var drug=$("#drugList").datagrid("getSelected").DrugDesc //ȥҩƷ
	//TempId
	commonShowWin({
		url:"dhcckb.predictner.csp?TempId="+TempId+"&DrugDesc="+drug,
		title:'�ı����',
		height:600,
		width:1300
	})
}

/**
* ������������
* @author zhouxin
*/
function commonShowWin(option){
		
		var content = '<iframe src="'+option.url+'" scrolling="auto" width="100%" height="98%" frameborder="0" scrolling="no"></iframe>';
		var defOpt={
			iconCls:"icon-w-paper",
			width: 1110,
			height: 600,
			closed: false,
			content: content,
			modal: true
		}
		$.extend(defOpt,option);
		if (document.getElementById("CommonWin")){
			winObj = $("#CommonWin");
		}else{
			winObj = $('<div id="CommonWin"></div>').appendTo("body");	
		}
		$('#CommonWin').dialog(defOpt);
}

function commonCloseWin(){
	$('#CommonWin').dialog('close');
}
function commonParentCloseWin(){
	window.parent.$('#CommonWin').dialog('close');
}
///�������
function saveTabooRow(retData)
{
	//debugger
	//var rowsData = $("#tabooList").datagrid('getSelected');
	//if(rowsData==null){
	//	$.messager.alert("��ʾ","û�д���������!");
	//	return;
	//}
	//var retData={};
	/*
	var opts = $('#tabooList').datagrid('getColumnFields');
	for(var i=0;i<opts.length;i++){
		var colOpt=$('#tabooList').datagrid('getColumnOption',opts[i]);
		if(colOpt.propId==''){continue;};
		var value=colOpt.propId;
		var desc=rowsData[colOpt.field];
		retData[value]=desc

	}*/
	// insert a new row at second row position
	$("#ruleList").datagrid('insertRow',{
		index: 1,	// index start with 0
		row:retData
		/*{
			name: 'new name',
			age: 30,
			note: 'some messages'
		}*/
	});
}

///����������
function addPredictRow(retData)
{
	
	var selTemp=$("#model").combobox('getValue');
	if(selTemp==""){
		$.messager.alert('��ʾ',"����ѡ��ģ�壡");
		return;
	}
	var DrugLibaryID=serverCall("web.DHCCKBRuleMaintain","DrugLibaryDataID",{"dicId":TempId});  		//��ȡģ��󶨵�Ŀ¼��ID������
	var array=DrugLibaryID.split("^")
	var ID=[array[0]];		//Ŀ¼ID��73��
	num=array[0];
	var catalog=array[1];	//Ŀ¼��������Ӧ֢��
	var e = $("#ruleList").datagrid('getColumnOption', 'catalog');
	
	///����ģ�壬��ȡ��ͬ���͵�ҽ��������
	var Temp=$("#modelTree").combobox('getText');
	//ȡ����ҩ������
	var Model = $("#model").combobox('getText');
	var seldrug=$("#drugList").datagrid("getSelected");
	///������ҩָ��������
	if(Model.indexOf("ָ��")>="0"){
		
	}else{
		e.editor = {};
	}
	
	if(Temp=="��ҩģ��"){
		var e = $("#ruleList").datagrid('getColumnOption', '81224');
		e.editor = {};
		retData['catalog']=catalog
		retData['catalogId']=ID
		retData['81224']=seldrug.DrugDesc
		retData['81224Id']=seldrug.DrugId
		retData['74698']='Y'
		retData['74698Id']='26852'
		if(Model.indexOf("�������")>="0"){
			retData['64']='����';
			retData['64Id']='3955';
		}
		if(Model.indexOf("�໥����")>="0"){
			retData['64']='���';
			retData['64Id']='4285';
		}
		if(Model.indexOf("ָ��")>="0"){
			retData['catalog']="";
			retData['catalogId']="";
		}
		commonAddRow({'datagrid':'#ruleList',value:retData})
		
	}else{
		/*
		var e = $("#ruleList").datagrid('getColumnOption', '81842');
		e.editor = {};
		if(Model.indexOf("�������")>="0"){
			commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81842":seldrug.DrugDesc,"81842Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"����","64Id":"3955"}})
		}else if(Model.indexOf("�໥����")>="0"){
			commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81842":seldrug.DrugDesc,"81842Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"���","64Id":"4285"}})
		}else{
			commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81842":seldrug.DrugDesc,"81842Id":seldrug.DrugId,"74698":"Y","74698Id":"26852"}})
		}
		*/
		var e = $("#ruleList").datagrid('getColumnOption', '81842');
		e.editor = {};
		retData['catalog']=catalog
		retData['catalogId']=ID
		retData['81842']=seldrug.DrugDesc
		retData['81842Id']=seldrug.DrugId
		retData['74698']='Y'
		retData['74698Id']='26852'
		if(Model.indexOf("�������")>="0"){
			retData['64']='����';
			retData['64Id']='3955';
		}
		if(Model.indexOf("�໥����")>="0"){
			retData['64']='���';
			retData['64Id']='4285';
		}
		if(Model.indexOf("ָ��")>="0"){
			retData['catalog']="";
			retData['catalogId']="";
		}
		commonAddRow({'datagrid':'#ruleList',value:retData})
	}
	
	dataGridBindEnterEvent(0);
		
	
}

function matchdiag()
{
	 var url = "http://172.19.19.90:8003/match_icd";
	 var Headers = {'content-type':'application/json'};
			$.ajax({
		    type: 'POST',
		    url: 'http://172.19.19.90:8003/match_icd',
		    crossDomain: true,
		    data: '{"terms":["������"],"source":["LC"],"dbname":"zhenduan","size":1}',
		    dataType: 'jsonp',
		    contentType:'application/json',
		    success: function(responseData) {
		       alert(responseData)
		    },
		    error: function (responseData, textStatus, errorThrown) {
		        alert('POST failed.');
		    }
    });
    
    
	
	  /*$.post(url,{"terms":["������"],"source":["LC"],"dbname":"zhenduan","size":1},function(data){
			 	alert(data)
			},Headers)
	  runClassMethod("web.DHCCKBPrescTest","GetOrgMatchDiag",{"filepath":""},function(data){
		 console.log(JSON.stringify(data))
		 
		  
		},'json','false') */
	 
}
