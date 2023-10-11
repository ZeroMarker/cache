/**
	sufan
	2020-04-23
	规则维护
*/
var editRow = "0",editTRow = "0",editRuleRow="0",editWinRow="0"; 
var TempId="",field="";
var selArray = [{"value":"0","text":'已保存'}, {"value":"1","text":'已提交'},{"value":"2","text":'全部'}];
$(function(){ 
	
	initButton();			//初始化按钮
	initcombobox();			//初始化规则维护主表
	initDrugList();			//初始化药品列表
	//initRuleList();		//初始化规则列表

})
///初始化按钮
function initButton()
{
	$("#insert").bind("click",InsertSouRow);	// 增加新行
	$("#save").bind("click",SaveRow);		// 保存
	$('#desc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			Query();
		}
	});
	$("#search").bind("click",Query);			// 保存
	
	$("#ruleins").bind("click",InsRuleRow)   	// 增加规则
	
	$("#rulesave").bind("click",SaveRuleRow)   	// 增加规则
	
	$("#rulesubmit").bind("click",subRuleRow)   // 提交规则
	
	$("#rulecan").bind("click",cancelRuleRow)   // 删除规则
	
	$("#rulecopy").bind("click",copyRuleRow)    // 复制规则
	
	$("#editprop").bind("click",editProp)       // 知识维护
	
	$("#multiplex").bind("click",multiPlex) 	// 复用
	
	$("#predictText").bind("click",predictText) ;	// 文本拆分
	
	$("#diagmatch").bind("click",matchdiag) ;
		
}
function initcombobox(){
	
	///模板类型
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
	///模板
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
	///检索条件
	$('#modellist').combobox({
		data:selArray,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option){
			if(TempId==""){
				$.messager.alert('提示','请先选择模板！')
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

///初始化下拉框
function initCombobox()
{
	$('#modellist').combobox({
		data:selArray,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option){
			if(dicId==""){
				$.messager.alert('提示','请先选择模板！')
				return;
			}
			var url=$URL+"?ClassName=web.DHCCKBRuleMaintain&MethodName=ListModelDataNew&params="+option.value;
			$('#drugList').datagrid('options').url=encodeURI(url)
        	$("#drugList").datagrid('reload');  
		} 
	})
}
///初始化药品列表
function initDrugList()
{
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'DrugId',title:'DrugId',width:100,align:'center',hidden:'true'},
		{field:'RuleFlag',title:'',width:30,align:'center'},
		{field:'DrugDesc',title:'药品名称',width:220,align:'center',editor:textEditor},
	]];
	
	///  定义datagrid  
	var option = {
		rownumbers : true,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#drugList").datagrid('endEdit', editRow); 
            } 
            $("#drugList").datagrid('beginEdit', rowIndex); 
            
            var editors = $('#drugList').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 失去焦点关闭编辑行                
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
	        	$.messager.alert('提示',"请先选择模板！")
	        	return;
	        }
        	initRuleList();
	    }
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBDrugRuleMaintain&MethodName=QueryDrugList"  //&params="+"&UserInfo="+LoginInfo;
	new ListComponent('drugList', columns, uniturl, option).Init(); 
}
///插入行
function InsertSouRow()
{
	if(editRow>="0"){
		$("#drugList").datagrid('endEdit', editRow);		//结束编辑，传入之前编辑的行
	}
	$("#drugList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {DrugId:'', DrugDesc:''} ,
		row: {}
	});
	$("#drugList").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	editRow=0;
}
///保存
function SaveRow()
{
	if(editRow>="0"){
		$("#drugList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#drugList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var Temp=$("#modelTree").combobox('getText');
	var parref=serverCall("web.DHCCKBDrugRuleMaintain","getDictionId",{"Temp":Temp});
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].DrugDesc==""){
			$.messager.alert("提示","描述不能为空!"); 
			return false;
		}
		if(parref==""){
			$.messager.alert("提示","请选择模板类型！"); 
			return false;
		}
		var tmp=$g(rowsData[i].DrugId) +"^"+ $g(rowsData[i].DrugDesc) +"^"+ $g(rowsData[i].DrugDesc) +"^"+ parref;
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";

	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		
		if (jsonString >= 0){
			$.messager.popover({msg: '保存成功！！',type:'success',timeout: 1000});
		}else if(jsonString == -98){
			$.messager.alert('提示','保存失败,代码重复！','warning');
			
		}else if(jsonString == -99){
			$.messager.alert('提示','保存失败,描述重复！','warning');

		}else{
			$.messager.alert('提示','保存失败！','warning');
		}		
		$('#drugList').datagrid('reload'); //重新加载
	});
}
///查询
function Query()
{
	var Temp=$("#modelTree").combobox('getText');
	var Desc=$.trim($("#desc").val());
	var params=Temp +"^"+ Desc; // 
	$('#drugList').datagrid('load',{params:params,UserInfo:LoginInfo});
}
///初始化规则列表
function initRuleList()
{
	
	runClassMethod("web.DHCCKBDrugRuleMaintain","ListModelDataGrid",{"dicId":TempId},function(data){
	
		var json= eval('(' + data + ')');
		
		var columns=[json];
		///  定义datagrid  
		var option = {
			rownumbers : true,
			//singleSelect : true,  //xww 2021-08-17 允许多选
			onClickRow:function(rowIndex,rowData){
 		    if (editRow != ""||editRow == 0) {    //wangxuejian 2021-05-21  关闭编辑行 
                $("#ruleList").datagrid('endEdit', editRow); 
             } 
 		    }, 
		    onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
				var seldrug=$("#drugList").datagrid("getSelected");
				var Temp=$("#modelTree").combobox('getText');
				var Model = $("#model").combobox('getText');
				if(Temp=="西药模板"){
					var e = $("#ruleList").datagrid('getColumnOption', '81224');
					e.editor = {};
					if(Model.indexOf("指导")>="0"){
						
					}else{
						var e = $("#ruleList").datagrid('getColumnOption', 'catalog');
						e.editor = {};
					}
				}else if(Temp.indexOf("指导")>="0"){
					var e = $("#ruleList").datagrid('getColumnOption', '81224');
					e.editor = {};
				}else if(Temp=="通用名模板"){
					var e = $("#ruleList").datagrid('getColumnOption', '74532');
					e.editor = {};
					if(Model.indexOf("指导")>="0"){
						
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
	            CommonRowClick(rowIndex,rowData,"#ruleList"); //编辑行
	            var editors = $('#ruleList').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 失去焦点关闭编辑行  
	             for (var i = 0; i < editors.length; i++)   
                {  
                   var e = editors[i]; 
              	   $(e.target).bind("blur",function()
              	   {  
                    //  $("#ruleList").datagrid('endEdit', rowIndex);
                    });   
                  
                  } 
                  editRow = rowIndex;
           		dataGridBindEnterEvent(rowIndex);				//主界面鼠标点击后显示字典datagrid
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
///新增规则行
function InsRuleRow()
{
	
	var selTemp=$("#model").combobox('getValue');
	if(selTemp==""){
		$.messager.alert('提示',"请先选择模板！");
		return;
	}
	var DrugLibaryID=serverCall("web.DHCCKBRuleMaintain","DrugLibaryDataID",{"dicId":TempId});  		//获取模板绑定的目录的ID和描述
	var array=DrugLibaryID.split("^")
	var ID=[array[0]];		//目录ID（73）
	num=array[0];
	var catalog=array[1];	//目录描述（适应症）
	var e = $("#ruleList").datagrid('getColumnOption', 'catalog');
	///根据模板，获取不同类型的医嘱项名称
	var Temp=$("#modelTree").combobox('getText');
	var Model = $("#model").combobox('getText');
	///设置用药指导下拉框
	if(Model.indexOf("指导")>="0"){
		
	}else{
		e.editor = {};
	}
	//取中西药名称列
	var seldrug=$("#drugList").datagrid("getSelected");
	if((Temp=="西药模板")){
		if(Model.indexOf("指导")>="0"){
			var e = $("#ruleList").datagrid('getColumnOption', '81224');
			e.editor = {};
			commonAddRow({'datagrid':'#ruleList',value:{"81224":seldrug.DrugDesc,"81224Id":seldrug.DrugId,"74698":"Y","74698Id":"26852"}})
		}else{
			var e = $("#ruleList").datagrid('getColumnOption', '81224');
			e.editor = {};
			if(Model.indexOf("配伍禁忌")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81224":seldrug.DrugDesc,"81224Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"组内","64Id":"3955"}})
			}else if(Model.indexOf("相互作用")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81224":seldrug.DrugDesc,"81224Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"组间","64Id":"4285"}})
			}else if(Model.indexOf("溶媒溶液")>="0"){
				//取药品是否为粉针剂或冻干粉针剂
				var IsPowderFlag=serverCall("web.DHCCKBRuleMaintain","IsPowderInjection",{'DrugId':seldrug.DrugId});
				if (IsPowderFlag==="Y"){
					//是的话必须稀释后给药默认为Y
					commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81224":seldrug.DrugDesc,"81224Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","81":"警示","81Id":"139","130544":"Y","130544Id":"26852"}})
				}else {
					commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81224":seldrug.DrugDesc,"81224Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","81":"警示","81Id":"139"}})
					}
			
			
			}
			else{
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81224":seldrug.DrugDesc,"81224Id":seldrug.DrugId,"74698":"Y","74698Id":"26852"}})
			}
		}
	}else{
		if((Model.indexOf("指导")>="0")&&(Model.indexOf("指导(通用名)")<"0")){
			var e = $("#ruleList").datagrid('getColumnOption', '81842');
			e.editor = {};
			commonAddRow({'datagrid':'#ruleList',value:{"81842":seldrug.DrugDesc,"81842Id":seldrug.DrugId,"74698":"Y","74698Id":"26852"}})	
					
			
		}
		if((Temp=="通用名模板")){
			var e = $("#ruleList").datagrid('getColumnOption', '74532');
			e.editor = {};
			if(Model.indexOf("配伍禁忌")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"74532":seldrug.DrugDesc,"74532Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"组内","64Id":"3955"}})

			}else if(Model.indexOf("相互作用")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"74532":seldrug.DrugDesc,"74532Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"组间","64Id":"4285"}})
			}
			else if(Model.indexOf("溶媒溶液")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"74532":seldrug.DrugDesc,"74532Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","81":"警示","81Id":"139"}})
			}
			else{
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"74532":seldrug.DrugDesc,"74532Id":seldrug.DrugId,"74698":"Y","74698Id":"26852"}})
			}
		}else{
			var e = $("#ruleList").datagrid('getColumnOption', '81842');
			e.editor = {};
			if(Model.indexOf("配伍禁忌")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81842":seldrug.DrugDesc,"81842Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"组内","64Id":"3955"}})

			}else if(Model.indexOf("相互作用")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81842":seldrug.DrugDesc,"81842Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"组间","64Id":"4285"}})
			}
			else if(Model.indexOf("溶媒溶液")>="0"){
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81842":seldrug.DrugDesc,"81842Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","81":"警示","81Id":"139"}})
			}
			else{
				commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81842":seldrug.DrugDesc,"74532Id":seldrug.DrugId,"74698":"Y","74698Id":"26852"}})
			}
		}
	}
	
	dataGridBindEnterEvent(0);
		
	
}
//主界面鼠标点击后显示字典datagrid
function dataGridBindEnterEvent(index){
	
	editRuleRow=index;
	var editors = $('#ruleList').datagrid('getEditors',index);
	for(var i=0;i<editors.length;i++){
		var workEditor = editors[i];
		editors[i].target.attr("field",editors[i].field);
		editors[i].target.mousedown(function(e){
				var DataDesc="",DataID=""
				field=$(this).attr("field");	 /// 模板中支持一个属性维护多次,对于多次维护的属性,格式是90975-mul qnp 2022-09-22			
				var fieldId=field+"Id";
				var ed=$("#ruleList").datagrid('getEditor',{index:index, field:field});		 
				var input = $(ed.target).val();															//内容
				var isDataSource=serverCall("web.DHCCKBRuleMaintain","isDataSource",{'field':((field.indexOf("-mul")!=-1)?field.split("-mul")[0]:field)}); 	//是否需要弹出窗口
				
				
				if((isDataSource==0)){
					var Array=[],dgObj={},Incolumns=[];
					var textEditor={
						type: 'text',//设置编辑格式
						options: {
							required: true //设置编辑规则属性
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
								if(jsonObj.rows[i].edtstr==""){ //默认格式
									dgObj.editor=textEditor;
								}else{		//维护的格式
									var tempeditor=jsonObj.rows[i].edtstr;		//后台格式串
									var tempObj={};								//编辑格式对象
									optionobj={};								//option 对象
									tempObj.type=tempeditor.split("@")[0];		//编辑格式
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
								  	{field:'DicDesc',title:'描述',width:60},
								  
								  ]] 
								},function(rowData){
									var ed=$("#ruleList").datagrid('getEditor',{index:index, field:field});	
									var IdEd=$("#ruleList").datagrid('getEditor',{index:index,field:field+"Id"});
									if(field=="catalog"){				//目录
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="83"){				//管制力度
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="81"){				//管理级别
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="89"){				//性别
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="65"){				//是否首次给药
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="64"){				//合用类别
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="74698"){			//消息提示标记
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else if(field=="40"){				//剂型
										$(ed.target).val(rowData.DicDesc);
										$(IdEd.target).val(rowData.DicID);
									}else{
										var input = $(ed.target).val();					//内容
										var fieldIdinput="";
										if(input=="")
										{
											DataDesc=rowData.DicDesc;
										}
										else{
											DataDesc=input+","+rowData.DicDesc;   		//描述
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
* @通用弹出div层
* @param 	width 	 	|string 	|宽度
* @param 	height 	 	|string 	|高度
* @param 	code 	 	|string 	|病历字典code
* @param 	adm 	 	|string 	|就诊表ID
* @param 	input 	 	|string 	|入参
* @param 	emrType 	|string 	|表单类型
* @param 	htmlType 	|string 	|html类型
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
		var retobj={};	// 返回对象
			
		///创建弹出窗体
	
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
		html=html+'<div><span>检索&nbsp;<input id="searchwin" type="text" class="textbox" style="width:123px;"/></span>';
		html=html+'<span style="margin-left:1px;"><a href="#" class="hisui-linkbutton"  iconCls="icon-search" plain="true" id="serchtbdt" >查询</a></span>'
		html=html+'<span style="margin-left:1px;"><a href="#" class="hisui-linkbutton"  iconCls="icon-add" plain="true" id="add" >增加行</a></span>';
		html=html+'<span id="inssou" style="margin-left:1px;display:none;"><a href="#" class="hisui-linkbutton"  iconCls="icon-add" plain="true" id="addDataSource" >增加数据源</a></span>'
		//html=html+'<div style="margin-top:5px" >'						//button start
		html=html+'	<span><a id="symbol1" style="margin-left:-10px;" href="#" class="hisui-linkbutton"  plain="true" name="!" >除外</a>'
		html=html+'		  <a id="symbol2" style="margin-left:-20px;" href="#" class="hisui-linkbutton" plain="true" name=">" >大于</a>'
		html=html+'		  <a id="symbol3" style="margin-left:-20px;" href="#" class="hisui-linkbutton"  plain="true" name=">=" >大于或等于</a>'
		html=html+'		  <a id="symbol4" style="margin-left:-20px;" href="#" class="hisui-linkbutton"  plain="true" name="<" >小于</a>'
		html=html+'		  <a id="symbol5" style="margin-left:-20px;" href="#" class="hisui-linkbutton"  plain="true" name="<=" >小于或等于</a>'
		html=html+'		  <a id="symbol6" style="margin-left:-20px;" href="#" class="hisui-linkbutton"  plain="true" name="~" >Between</a>'
		html=html+'		  <a id="symbol7" style="margin-left:-20px;" href="#" class="hisui-linkbutton"  plain="true" name="!=" >不等于</a>'
		html=html+' </span>'
		html=html+'</div>'    //button end
		html=html+'</div>';														//toolbar end
		html=html+'</div>';
		html=html+' <div data-options="region:\'south\',title:\'\',border:false,collapsible:false" style="text-align:center;background-color:#eee;">';
		html=html+'		<a href="#" class="hisui-linkbutton" id="saveDivWinBTN"  style="width:60px" >保存</a>';
		html=html+'		<a href="#" class="hisui-linkbutton"  id="removeDivWinBTN" style="width:60px"  >关闭</a>';
		html=html+'</div>';
		html=html+'</div>';
		
		$("#win").append(html);
		
		/**控制新增数据源按钮的显示**/
		var coltitle = serverCall("web.DHCCKBDrugRuleMaintain","GetColFieldTitle",{"filed":((option.filed.indexOf("-mul")!=-1)?option.filed.split("-mul")[0]:option.filed)});
		if(coltitle.indexOf("疾病")>=0){
			$("#inssou").show();
		}
		if (option.htmlType == "datagrid"){
			// 定义columns
			var columns=[[  
					{field:'DicID',title:'RowId',hidden:true},
					{field:'Alias',title:'别名',width:450,align:'center'},
					{field:'DicCode',title:'代码',width:150,align:'center'},
					{field:'DicDesc',title:'描述',width:300,align:'center'},
					{field:'ParrefDesc',title:'父节点',width:160,align:'center'}
					/*{field:'CDTypeDesc',title:'类型',width:300,align:'center'},
					{field:'CDLinkDr',title:'关联ID',width:300,align:'center'}		 */			
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
				onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
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
		var $left=option.tarobj.offset().left<option.width?option.tarobj.offset().left:(option.tarobj.offset().left-(document.body.offsetWidth/2-option.width)); // 处理左侧被遮盖的情况
		if (document.body.offsetWidth-option.tarobj.offset().left<option.width){	// 处理右侧被遮盖的情况
			$left=document.body.offsetWidth-option.width;
		}		
		$("#win").css("left",$left);
		
		var winTop=option.tarobj.offset().top+ option.tarobj.outerHeight();		// win距离顶部的位置
		var winHieght=option.height;											// win本身的宽度
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
		
		// 查询
		$("#serchtbdt").on('click',function(){
			var searchDesc = $.trim($("#searchwin").val());
			$("#divAttrTable").datagrid("load",{"id":id,"parDesc":searchDesc}); 
		});
		///回车查询
		$('#searchwin').bind('keypress',function(event){
	        if(event.keyCode == "13")    
	        {
	            var searchDesc = $.trim($("#searchwin").val());
				$("#divAttrTable").datagrid("load",{"id":id,"parDesc":searchDesc}); 
	        }
    	});
		///按钮区域
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
///符号插入
function SymbolClick(stmbol)
{
	var ed=$("#ruleList").datagrid('getEditor',{index:editRuleRow, field:field});
	$(ed.target).insertAtCaret(stmbol);
}
///新增行
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
		saveDataSour="" //表示为增加行按钮的标识
		if(editWinRow>="0"){
			$("#divAttrTable").datagrid('endEdit', editWinRow);		//结束编辑，传入之前编辑的行
		}
		$("#divAttrTable").datagrid('insertRow', {
			index: 0, // 行数从0开始计算
			row: {}
		});
		
		$("#divAttrTable").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
		editWinRow=0;
	})
}

///增加数据到对应的数据源
function insertDataRow(){
	var searchDesc = $("#searchwin").val();
	if (searchDesc=="")
	{
		$.messager.alert("提示","没有待添加数据");
		$("#win").remove();
		return;
	}
	var params="^^"+searchDesc+"^"+field;
	
	//保存数据
	runClassMethod("web.DHCCKBRuleMaintain","saveOrUpdateData",{"params":params,"LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
		if (jsonString == 0){
			$.messager.popover({msg: '保存成功！！',type:'success',timeout: 1000});
		}else if(jsonString==-1){
			$.messager.alert('提示','代码存在!','warning');
		}else if(jsonString==-2){
			$.messager.alert('提示','描述存在!','warning');
		}else{
			$.messager.alert('提示','保存失败!','warning');
		}
		$('#divAttrTable').datagrid('reload'); //重新加载	
	});
}
///保存规则
function SaveRuleRow()
{
	if(!endEditing("#ruleList")){
		$.messager.alert("提示","请编辑必填数据!");
		return;
	}
	//2020-04-13 一次性保存多条
	var rowsData = $("#ruleList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var opts = $('#ruleList').datagrid('getColumnFields');
	var dataListAll = [];
	for(var j=0;j<rowsData.length;j++){
		var dataList = [];
		for(var i=0;i<opts.length;i++){
			var colOpt=$('#ruleList').datagrid('getColumnOption',opts[i])
			if (colOpt.field == "ShowFlag"){	// qunianpeng 2020-04-30 过滤状态列
				continue;	
			}
			var	catId = rowsData[j][colOpt.field]
			if((colOpt.field=="catalogId")&&($.trim(catId)=="")){
					$.messager.alert("提示","用药指导不能为空！")
					return false;
			}
			if(colOpt.hidden===false){
				var	desc=rowsData[j][colOpt.field];   //没有数据源的取描述
				if((colOpt.field=="82")&&($.trim(desc)=="")){
					$.messager.alert("提示","提示信息不能为空！")
					return false;
				}
				if((colOpt.field=="catalog")&&($.trim(desc)=="")){
					$.messager.alert("提示","用药指导不能为空！")
					return false;
				}
				var ID=rowsData[j].ID;
				if(ID==null){
					ID="";
				}
				var value=colOpt.field
				if(value=="catalog"){    			  //对上级是目录字典的特殊处理
					
					var DrugLibaryID=serverCall("web.DHCCKBRuleMaintain","DrugLibaryDataID",{"dicId":TempId});
					var array=DrugLibaryID.split("^")
					num=array[0];
					value=num;
					if((array[1]=="用药指导")&&(ID=="")){
						value = rowsData[j][colOpt.field+"Id"];
					}
					if((array[1]=="用药指导")&&(ID!="")){
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
	
		//保存数据
	runClassMethod("web.DHCCKBRuleMaintain","saveAll",{"params":mListDataAll},function(jsonString){
		if (jsonString == 0){
			$.messager.alert('提示','保存成功！','info');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		$('#ruleList').datagrid('reload'); //重新加载	
		
	});
	///end 2020-04-13
}
///提交规则
function subRuleRow()
{
	/*var Selected=$('#ruleList').datagrid('getSelected')
	if(Selected==null){
		$.messager.alert("提示","请选择记录");
		return;
	}*/
	
	//xww 2021-08-17批量提交
	var SelectParams = $("#ruleList").datagrid('getSelections');
	if(SelectParams.length==0)
	{
		$.messager.alert('提示',"请选择记录");
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
			$.messager.alert("提示","药品名称【通用名(带剂型)】不能为空！");
		}
		if(jsonstring.code=="-2"){
			$.messager.alert("提示","提示级别不能为空！");
		}
		if(jsonstring.code=="success"){
			$.messager.alert("提示","提交成功！");
		}
		if(jsonstring.code=="err"){
			
			$.messager.alert("提示","提交失败！"+jsonstring.content);
		}
		$('#ruleList').datagrid('reload');
	});
}
///删除
function cancelModelRow()
{
	var Selected=$('#ruleList').datagrid('getSelected')
	if(Selected==null){
		$.messager.alert("提示","请选择记录");
		return;
	}
	
	runClassMethod("web.DHCCKBRuleMaintain","UpdSubFlag",{"GroupNo":Selected.GroupNo,"Flag":3},function(jsonstring){
		if(jsonstring!="0"){
			$.messager.alert("提示","删除失败！");
		}
		$('#ruleList').datagrid('reload');
	});
}
///删除
function cancelRuleRow()
{
	var Selected=$('#ruleList').datagrid('getSelected')
	if(Selected==null){
		$.messager.alert("提示","请选择记录");
		return;
	}
	
	runClassMethod("web.DHCCKBRule","UpdSubFlag",{"GroupNo":Selected.GroupNo,"Flag":3,"rule":Selected.ruleId},function(jsonstring){
		if(jsonstring!="0"){
			$.messager.alert("提示","删除失败！");
		}
		$('#ruleList').datagrid('reload');
	});
}
///复制规则
function copyRuleRow()
{
	/* $.messager.alert('提示',"功能待完善！")
	return; */
	var seltems=$('#ruleList').datagrid('getSelections')
	if(seltems==null){
		$.messager.alert("提示","请选择记录");
		return;
	}
	var Fieldopts = $('#ruleList').datagrid('getColumnFields');

	var dataListAll = [];
	for(var j=0;j<seltems.length;j++){
		var dataList = [];
		for(var i=0;i<Fieldopts.length;i++){
			var colOpt=$('#ruleList').datagrid('getColumnOption',Fieldopts[i])
			if (colOpt.field == "ShowFlag"){	// qunianpeng 2020-04-30 过滤状态列
				continue;	
			}
			if(colOpt.hidden===false){
				var	desc=seltems[j][colOpt.field];   //没有数据源的取描述
				var ID=""
				var value=colOpt.field
				if(value=="catalog"){    			  //对上级是目录字典的特殊处理
					var DrugLibaryID=serverCall("web.DHCCKBRuleMaintain","DrugLibaryDataID",{"dicId":TempId});
					var array=DrugLibaryID.split("^")
					num=array[0];
					value=num;	
					if(array[1]=="用药指导"){
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
			$.messager.popover({msg: '保存成功！！',type:'success',timeout: 1000});
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		$('#ruleList').datagrid('reload'); //重新加载	
		
	});
}
///知识维护
function editProp()
{
	var seltems=$('#drugList').datagrid('getSelected')
	if(seltems==null){
		$.messager.alert("提示","请选择药品列表！");
		return;
	}
	
	var DrugId = seltems.DrugId; 
	var dicParref = serverCall("web.DHCCKBDrugRuleMaintain","GetEntyId",{"DrugId":DrugId})
	var linkUrl="dhcckb.editprop.csp"

	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'?parref='+DrugId+'&dicParref='+dicParref+'"></iframe>';

	if($('#win').is(":visible")){
		$("#win").remove();
	}
	if($('#winmodel').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:'实体知识维护',
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
///停用数据复用
function multiPlex()
{
	var linkUrl="dhcckb.stopdata.csp"

	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'"></iframe>';
	if($('#win').is(":visible")){
		$("#win").remove();
	}
	if($('#winstop').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winstop"></div>');
	$('#winstop').window({
		title:'停用数据复用',
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
	var str=str.replace("′","^")   //替换为搜狗，特殊符号，数学符号里的 "′";
	return str;
}
///界面加载完成之后
window.onload = function(){
	setTimeout(function(){
		var Temptype=$("#modelTree").combobox('getText');
		var TemptypeId=$("#modelTree").combobox('getValue');
		//$('#drugList').datagrid('load',{params:Temptype});
		var unitUrl = $URL+"?ClassName=web.DHCCKBDrugRuleMaintain&MethodName=ListModel&TypeId="+TemptypeId;
		$("#model").combobox('reload',unitUrl);
	},400)
}
///文本拆分
function predictText(){
	var drug=$("#drugList").datagrid("getSelected").DrugDesc //去药品
	//TempId
	commonShowWin({
		url:"dhcckb.predictner.csp?TempId="+TempId+"&DrugDesc="+drug,
		title:'文本拆分',
		height:600,
		width:1300
	})
}

/**
* 公共弹出界面
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
///保存规则
function saveTabooRow(retData)
{
	//debugger
	//var rowsData = $("#tabooList").datagrid('getSelected');
	//if(rowsData==null){
	//	$.messager.alert("提示","没有待保存数据!");
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

///新增规则行
function addPredictRow(retData)
{
	
	var selTemp=$("#model").combobox('getValue');
	if(selTemp==""){
		$.messager.alert('提示',"请先选择模板！");
		return;
	}
	var DrugLibaryID=serverCall("web.DHCCKBRuleMaintain","DrugLibaryDataID",{"dicId":TempId});  		//获取模板绑定的目录的ID和描述
	var array=DrugLibaryID.split("^")
	var ID=[array[0]];		//目录ID（73）
	num=array[0];
	var catalog=array[1];	//目录描述（适应症）
	var e = $("#ruleList").datagrid('getColumnOption', 'catalog');
	
	///根据模板，获取不同类型的医嘱项名称
	var Temp=$("#modelTree").combobox('getText');
	//取中西药名称列
	var Model = $("#model").combobox('getText');
	var seldrug=$("#drugList").datagrid("getSelected");
	///设置用药指导下拉框
	if(Model.indexOf("指导")>="0"){
		
	}else{
		e.editor = {};
	}
	
	if(Temp=="西药模板"){
		var e = $("#ruleList").datagrid('getColumnOption', '81224');
		e.editor = {};
		retData['catalog']=catalog
		retData['catalogId']=ID
		retData['81224']=seldrug.DrugDesc
		retData['81224Id']=seldrug.DrugId
		retData['74698']='Y'
		retData['74698Id']='26852'
		if(Model.indexOf("配伍禁忌")>="0"){
			retData['64']='组内';
			retData['64Id']='3955';
		}
		if(Model.indexOf("相互作用")>="0"){
			retData['64']='组间';
			retData['64Id']='4285';
		}
		if(Model.indexOf("指导")>="0"){
			retData['catalog']="";
			retData['catalogId']="";
		}
		commonAddRow({'datagrid':'#ruleList',value:retData})
		
	}else{
		/*
		var e = $("#ruleList").datagrid('getColumnOption', '81842');
		e.editor = {};
		if(Model.indexOf("配伍禁忌")>="0"){
			commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81842":seldrug.DrugDesc,"81842Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"组内","64Id":"3955"}})
		}else if(Model.indexOf("相互作用")>="0"){
			commonAddRow({'datagrid':'#ruleList',value:{"catalog":catalog,"catalogId":ID,"81842":seldrug.DrugDesc,"81842Id":seldrug.DrugId,"74698":"Y","74698Id":"26852","64":"组间","64Id":"4285"}})
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
		if(Model.indexOf("配伍禁忌")>="0"){
			retData['64']='组内';
			retData['64Id']='3955';
		}
		if(Model.indexOf("相互作用")>="0"){
			retData['64']='组间';
			retData['64Id']='4285';
		}
		if(Model.indexOf("指导")>="0"){
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
		    data: '{"terms":["度烧伤"],"source":["LC"],"dbname":"zhenduan","size":1}',
		    dataType: 'jsonp',
		    contentType:'application/json',
		    success: function(responseData) {
		       alert(responseData)
		    },
		    error: function (responseData, textStatus, errorThrown) {
		        alert('POST failed.');
		    }
    });
    
    
	
	  /*$.post(url,{"terms":["度烧伤"],"source":["LC"],"dbname":"zhenduan","size":1},function(data){
			 	alert(data)
			},Headers)
	  runClassMethod("web.DHCCKBPrescTest","GetOrgMatchDiag",{"filepath":""},function(data){
		 console.log(JSON.stringify(data))
		 
		  
		},'json','false') */
	 
}
