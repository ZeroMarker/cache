/**
	xiaowenwu 
	2020-01-15
	规则维护
*/
var editDRow = "0",editRow="",editPRow="0"; 
var dicId="",num="",field="";
var saveDataSour=""; //是否为添加数据源按钮的保存事件
var selArray = [{"value":"0","text":'已保存'}, {"value":"1","text":'已提交'},{"value":"2","text":'全部'}];
$(function(){ 

	inittree();		//初始化规则维护主表
	initCombobox();
	//initDataTable(); //初始化规则维护子表

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
					displayMsg: '共{total}记录',
					onDblClickRow: function (rowIndex, rowData) {		//双击选择行编辑
          			 	CommonRowClick(rowIndex,rowData,"#modelTable"); //编辑行
           				dataGridBindEnterEvent(rowIndex);				//主界面鼠标点击后显示字典datagrid
           				
        			},
        			onClickRow:function(rowIndex, rowData){
	        			}
					});
			},"text");
	    }
	});
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
			var url=$URL+"?ClassName=web.DHCCKBRuleMaintain&MethodName=ListModelDataNew&parent="+dicId+"&params="+option.value;
			$('#modelTable').datagrid('options').url=url;
        	$("#modelTable").datagrid('reload');  
		} 
	})
}
//增加主界面行
function addModelRow(){
	var DrugLibaryID=serverCall("web.DHCCKBRuleMaintain","DrugLibaryDataID",{"dicId":dicId});  //获取模板绑定的目录的ID和描述
	var array=DrugLibaryID.split("^")
	var ID=[array[0]];		//目录ID（73）
	num=array[0];
	var catalog=array[1];	//目录描述（适应症）
	commonAddRow({'datagrid':'#modelTable',value:{"catalog":catalog,"catalogId":ID}})
	dataGridBindEnterEvent(0);
}

//主界面鼠标点击后显示字典datagrid
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
				var input = $(ed.target).val();														//内容
				//var edId=$("#modelTable").datagrid('getEditor',{index:index, field:fieldId});		//内容隐藏ID
				//var fieldIdinput = $(edId.target).val();
				var isDataSource=serverCall("web.DHCCKBRuleMaintain","isDataSource",{'field':field}); //是否需要弹出窗口
				if((isDataSource==0)){
					var Array=[],dgObj={},Incolumns=[];
					var textEditor={
						type: 'text',//设置编辑格式
						options: {
							required: true //设置编辑规则属性
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
								  	{field:'CDDesc',title:'描述',width:60},
								  
								  ]] 
								},function(rowData){
									var ed=$("#modelTable").datagrid('getEditor',{index:index, field:field});		 
									var input = $(ed.target).val();					//内容
									var fieldIdinput="";
									if(input=="")
									{
										DataDesc=rowData.CDDesc;
									}
									else{
										DataDesc=input+","+rowData.CDDesc;   		//描述
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


/// 保存主界面编辑行
function saveModelRow(){
	if(!endEditing("#modelTable")){
		$.messager.alert("提示","请编辑必填数据!");
		return;
	}
	//2020-04-13 一次性保存多条
	var rowsData = $("#modelTable").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var opts = $('#modelTable').datagrid('getColumnFields');
	var dataListAll = [];
	for(var j=0;j<rowsData.length;j++){
		var dataList = [];
		for(var i=0;i<opts.length;i++){
			var colOpt=$('#modelTable').datagrid('getColumnOption',opts[i])
			if(colOpt.hidden===false){
				var	desc=rowsData[j][colOpt.field];   //没有数据源的取描述
				if((colOpt.field=="82")&&($.trim(desc)=="")){
					$.messager.alert("提示","提示信心不能为空！")
					return false;
				}
				var ID=rowsData[j].ID;
				if(ID==null){
					ID="";
				}
				var value=colOpt.field
				if(value=="catalog"){    			  //对上级是目录字典的特殊处理
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
		//保存数据
	runClassMethod("web.DHCCKBRuleMaintain","saveAll",{"params":mListDataAll},function(jsonString){
		if (jsonString == 0){
			$.messager.alert('提示','保存成功！','info');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		$('#modelTable').datagrid('reload'); //重新加载	
		
	});
	///end 2020-04-13
}
///提交规则
function submitModelRow()
{
	var Selected=$('#modelTable').datagrid('getSelected')
	if(Selected==null){
		$.messager.alert("提示","请选择记录");
		return;
	}
	
	runClassMethod("web.DHCCKBRuleMaintain","SubmitRule",{"GroupNo":Selected.GroupNo,"LoginInfo":LoginInfo},function(jsonstring){
		if(jsonstring=="-1"){
			$.messager.alert("提示","药品名称【通用名(带剂型)】不能为空！");
		}
		if(jsonstring=="-2"){
			$.messager.alert("提示","提示级别不能为空！");
		}
		if(jsonstring.code=="success"){
			$.messager.alert("提示","提交成功！");
		}
		$('#modelTable').datagrid('reload');
	});
}
///删除
function cancelModelRow()
{
	var Selected=$('#modelTable').datagrid('getSelected')
	if(Selected==null){
		$.messager.alert("提示","请选择记录");
		return;
	}
	
	runClassMethod("web.DHCCKBRuleMaintain","UpdSubFlag",{"GroupNo":Selected.GroupNo,"Flag":3},function(jsonstring){
		if(jsonstring!="0"){
			$.messager.alert("提示","删除失败！");
		}
		$('#modelTable').datagrid('reload');
	});
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
		html=html+'<div><span>检索&nbsp;<input id="search" type="text" class="textbox" style="width:123px;"/></span>';
		html=html+'<span style="margin-left:1px;"><a href="#" class="hisui-linkbutton"  iconCls="icon-search" plain="true" id="serchtbdt" >查询</a></span>'
		html=html+'<span style="margin-left:1px;"><a href="#" class="hisui-linkbutton"  iconCls="icon-add" plain="true" id="add" >增加行</a></span>';
		html=html+'<span style="margin-left:1px;"><a href="#" class="hisui-linkbutton"  iconCls="icon-add" plain="true" id="addDataSource" >增加数据源</a></span></div>'
		html=html+'<div style="margin-top:5px" >'						//button start
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
		
		if (option.htmlType == "datagrid"){
			// 定义columns
			var columns=[[  
					{field:'ID',title:'RowId',hidden:true},
					{field:'Alias',title:'别名',width:300,align:'center'},
					{field:'CDCode',title:'代码',width:200,align:'center'},
					{field:'CDDesc',title:'描述',width:200,align:'center'},
					{field:'CDParrefDesc',title:'父节点',width:100,align:'center'}
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
		 			if(option.Incolumns==""){
			 			callback(rowData);
			 		}  
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
			        var isLeaf = $("#divAttrTable").tree('isLeaf',node.target);   /// 是否是叶子节点
			        if (isLeaf){
				        //$(option.tarobj).val(itmText); 		
						//$(ed.target).val(itmID);							
						$("#win").remove();	
			        }else{
				    	//$("#divAttrTable").tree('toggle',node.target);   /// 点击项目时,直接展开/关闭
				    }
				    $(option.tarobj).val(node.text);
				    callback(node);
			    },
			    onExpand:function(node, checked){
					var childNode = $("#divAttrTable").tree('getChildren',node.target)[0];  /// 当前节点的子节点
			        var isLeaf = $("#divAttrTable").tree('isLeaf',childNode.target);        /// 是否是叶子节点
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
		var winTop=option.tarobj.offset().top+ option.tarobj.outerHeight();		// win距离顶部的位置
		var winHieght=option.height;											// win本身的宽度
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
					$.messager.alert("提示","没有待保存数据!");
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
		saveDataSour="" //表示为增加行按钮的标识
		if(editDRow>="0"){
			$("#divAttrTable").datagrid('endEdit', editDRow);		//结束编辑，传入之前编辑的行
		}
		$("#divAttrTable").datagrid('insertRow', {
			index: 0, // 行数从0开始计算
			row: {}
		});
		
		$("#divAttrTable").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
		editDRow=0;
	})
}

///增加数据到对应的数据源
function insertDataRow(){
	var searchDesc = $("#search").val();
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
	
	
	/**	var fileds=$('#divAttrTable').datagrid('getColumnFields');
	var params=fileds.join("&&");
	runClassMethod("web.DHCCKBDicLinkAttr","getEditors",{"FiledList":params},function(jsonString){
		for(var j=0;j<jsonString.length;j++)
		{
			if(jsonString[j].editors=="combobox"){
				$.messager.alert("提示","此项不能添加到数据源");
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
					required: true, //设置编辑规则属性
				 }
			  }
			}	
		}
		saveDataSour=1  //表示为保存数据源按钮的标识
		if(editDRow>="0"){
			$("#divAttrTable").datagrid('endEdit', editPRow);		//结束编辑，传入之前编辑的行
		}
		$("#divAttrTable").datagrid('insertRow', {
			index: 0, // 行数从0开始计算
			row: {}
		});
		
		$("#divAttrTable").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
		editPRow=0;
	})	*/
}
