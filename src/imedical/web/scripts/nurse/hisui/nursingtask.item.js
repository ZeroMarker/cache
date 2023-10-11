
var entity=""
var xcTopContors=""
var xcChange={}
$.fn.watch = function (callback) {
        return this.each(function () {
            //缓存以前的值
            $.data(this, 'originVal', $(this).val());
            $(this).on('keyup paste input propertychange', function () {
                var originVal = $.data(this, 'originVal');
                var currentVal = $(this).val();
                if (originVal !== currentVal) {
                    $.data(this, 'originVal', $(this).val());
                    callback(currentVal,originVal,$(this));
                }
            });
        });
    }

function setAllParms(parms){
	var rtnParms={}
	for(var i=0;i<parms.length;i++){
		var parmArray=parms[i]
		for(var key in parmArray){
			var value=parmArray[key]
			if(value!=""){
				rtnParms[key]=value	
			}
		}
	}
	return rtnParms;
	
	
}

var dict={
	local:function(type){
		var rtnData=[]
		runClassMethod("Nur.SHIFT.Config.ShiftDict","GetDictByType",{Type:type},function(rtn){
			rtnData=rtn
		},'json',false);
		return rtnData;
	},
	data:function(type){
		var dicts={
			"shift_detail_group":[{value:"1",text:"患者信息列"},{value:"2",text:"交班内容列"}],
			"shift_open":[{value:"1",text:"启用"},{value:"0",text:"禁用"}],
			"shift_yesorno":[{value:"1",text:"是"},{value:"0",text:"否"}],
			"shift_fild_type":[{value:"1",text:"患者信息"},
							 {value:"2",text:"交班项目"},
							 {value:"3",text:"自定义"},
							 ],
			"shift_age":[
						{value:"1",text:"新生儿(<28天)"},
						{value:"2",text:"28天<婴儿<=1岁"},
						{value:"3",text:"1岁<儿童<=14岁"},
						{value:"4",text:"成人(>14岁)"},
						
						],
			"shift_book_type":[
						{value:"1",text:"病区"},
						{value:"2",text:"科室"},
						{value:"3",text:"产房"},
						{value:"4",text:"新生儿"},
						],
			"shift_into_next":[
						{value:"0",text:"否"},
						{value:"1",text:"当日"},
						{value:"2",text:"跨天"},
						],
			"shift_sum_method":[
						{value:"0",text:"不带入"},
						{value:"1",text:"累计"},
						{value:"2",text:"最新值"},
						{value:"3",text:"最高值"},
						],
		}
		return dicts[type]
	}
}

function resultParms(xcContors){
	var parm={}
	var isNullContor=""
	for(var i=0;i<xcContors.length;i++){
		var contor=xcContors[i]
		var contor_type=contor.type
		var contor_id=contor.id
		var contor_required=contor.required
		if(isUndefined(contor_type)){
			continue;
		}	
		parm[contor_id]=""
		var isExit =$("#"+contor_id).length
		if(isExit==0){
			continue;
		}
		var IsHide=$("tr[name="+contor_id+"]").hasClass("IsHide")
		if(IsHide){
			continue;
		}
		//console.log(contor_id)
		var value=""
		if("combox"==contor_type){
			var contor_multiple=contor.multiple
			if(isUndefined(contor_multiple)){
				value = $("#"+contor_id).combo("getValue")
			}else{
				value = $("#"+contor_id).combo("getValues")	
				value = value.join(",")
			}
		}else if("comboxGrid"==contor_type){
			var values=[]
			var $div = $("#"+contor_id).siblings("span.combo").find("div.div-combo-text")
			$div.find('span').each(function(){
				var val = $(this).attr("id")
				values.push(val)
			})
			value= values.join(",")
		}else{
			value= $("#"+contor_id).val()
		}
		parm[contor_id]=value
		if(!isUndefined(contor_required)){
			if(value==""){
				isNullContor=contor
				break;	
			}
		}
	}
	if(isNullContor!=""){
		//console.log(isNullContor)
		return ""
	}
	return parm
	
}


//初始化下拉框按钮的点击事件
var onChangeIds=[]

function changeNew(allContors,showIds,$thisId,value){
	
	if(onChangeIds.indexOf($thisId)<0){
		onChangeIds.push($thisId)
		//return; 	
	}
	
	for(var i=0;i<showIds.length;i++){
		var showObj=showIds[i]
		var key=showObj.key
		var ids=showObj.value
		for(var j=0;j<ids.length;j++){
			var showId=ids[j]
			$("tr[name="+showId+"]").hide()
			
		}
		
	}
	for(var i=0;i<showIds.length;i++){
		var showObj=showIds[i]
		var key=showObj.key
		var ids=showObj.value
		for(var j=(ids.length-1);j>=0;j--){
			var showId=ids[j]
			if(value==key){
				createInputHtml($thisId,allContors,showId,1)
			}
		}
		
	}
	
}

function change(showIds,$thisId,value){
	
	if(onChangeIds.indexOf($thisId)<0){
		onChangeIds.push($thisId)
		//return; 	
	}
	
	for(var i=0;i<showIds.length;i++){
		var showObj=showIds[i]
		var key=showObj.key
		var ids=showObj.value
		for(var j=0;j<ids.length;j++){
			var showId=ids[j]
			$("tr[name="+showId+"]").remove()
			
		}
		
	}
	for(var i=0;i<showIds.length;i++){
		var showObj=showIds[i]
		var key=showObj.key
		var ids=showObj.value
		for(var j=0;j<ids.length;j++){
			var showId=ids[j]
			if(value==key){
				createInputHtml($thisId,xcContors,showId,1)
			}
		}
		
	}
	
}
var $create={
	html:function(controlArrs,tableID){
		for(var i=0;i<controlArrs.length;i++){
			var key = controlArrs[i].id
			createInputHtml(tableID,controlArrs,key,0)
		}
	},
	textvalue:function(text,value){
		return {"value":value,"text":$g(text)}
	},
}
function doHtml(controlArrs,tableID){
	for(var i=0;i<controlArrs.length;i++){
		var key = controlArrs[i].id
		createInputHtml(tableID,controlArrs,key,0)
	}
	
	var inputw=0
	for(var i=0;i<controlArrs.length;i++){
		var obj = controlArrs[i]
		var thisw=$("#"+obj.id).parents("td").outerWidth()-17
		if(thisw>inputw) inputw=thisw
		obj.width=inputw
	}
	
	for(var i=0;i<controlArrs.length;i++){
		var obj = controlArrs[i]
		if(typeof(obj.style)=="undefined"){
			$("#"+obj.id).width(inputw)
			$("#"+obj.id).parents("tr.xc-design").each(function(){
				$(this).find("td").each(function(){
					var w=$(this).width()	
					//$(this).css({width:w})
				})	
			})
		}else{
			$("#"+obj.id).css(obj.style)
		}
		if(obj.type=="combox"){
			getComboxLocalData(obj)
		}
		if(!isUndefined(obj.color)){
		
			$("#"+obj.id).attr("type","color")
			$("#"+obj.id).color({
				editable:true,
				required:true,
				width:inputw+7,
				height:30
			});

		}
		
		
	}
	
}




function createInputHtml(tableId,contorls,contorlsId,isAppend){
	for(var i=0;i<contorls.length;i++){
		var obj = contorls[i]
		if(entity !=""){
			//给文本默认赋值
			if(!isUndefined(entity[obj.id])){
				obj.defaultValue=entity[obj.id]
			}
			
		}
		if(!isUndefined(obj.pid)){
			continue;
		}
		
		//取控件信息
		var id = obj.id
		if(!isUndefined(contorlsId) && contorlsId!=""){
			if(id!=contorlsId){
				continue
			}
		}
		//判断界面中是否存在contorlsId控件
		var contorlen=$("#"+tableId).find("tr[name="+contorlsId+"]").length
		if(contorlen>0){
			continue;
		}
		//取控件的子控件
		var childs=[]
		for(var j=0;j<contorls.length;j++){
			if(!isUndefined(contorls[j].pid)){
				if(id==contorls[j].pid){
					childs.push(contorls[j])
				}
			}
		}
		
		var tds=[]
		if(childs.length>0){
			for(var m=0;m<childs.length;m++){
				if(!isUndefined(childs[m].title)){
					
					if(childs[m].title!=""){
						var title=""
						if(!isUndefined(childs[m].required)){
							title='<label class="ant-form-item-required" style="white-space: nowrap;">'+childs[m].title+'</label>'
						}else{
							title="<span class='ant-form-item'>"+childs[m].title+"</span>"
						}
						
						tds.push(title)
					}
				}
				if(!isUndefined(childs[m].type)){
					tds.push(rsInputHtml(childs[m]))
				}
			}
		}else{
			tds.push(rsInputHtml(obj))
		}
		
		
		
		var vsReminder=""
		if(!isUndefined(obj.reminder)){
			$(".vsReminder").find("a.hisui-linkbutton").attr("id",obj.id+"_tip")
			var vsReminder = $(".vsReminder").html()
		}
		var title=""
		if(!isUndefined(obj.title)){
			if(obj.title!="") title=obj.title
		}
		
		if(!isUndefined(obj.required)){
			title='<label class="ant-form-item-required" style="white-space: nowrap;">'+title+'</label>'
		}
		var html=""
		if(title==""){
			html='<tr class="xc-design" name="'+obj.id+'">'+
		  
		   '<td colspan="2">'+tds.join("")+vsReminder+'</td>'+
		   '</tr>'
		}else{
		 	html='<tr class="xc-design" name="'+obj.id+'">'+
		   '<td class="tdlabel"><span class="ant-form-item">'+title+'</span></td>'+
		   '<td>'+tds.join("")+vsReminder+'</td>'+
		   '</tr>'
		}
	   if(isAppend=="0" || isAppend==0){
		    $("#"+tableId).addClass("xctable").append(html)
		}else{
			$("#"+tableId).parents("tr").after(html)
			//$("#"+tableId).append(html)
		}
		var inputw=$("#"+obj.id).outerWidth()
		
		if(!isUndefined(obj.hidden)){
			$("tr[name="+obj.id+"]").hide().addClass("IsHidden")
		}
		
		
		
		
		/*$("tr[name=NTONRelationNDayExeTime]").hide()
			$("tr[name=cxjgzq]").hide()
		$("#NTONRelationPeriod").watch(function(value,oldval,ele) {
			$("tr[name=NTONRelationNDayExeTime]").hide()
			$("tr[name=cxjgzq]").hide()
			if(value!="" && value>0){
				$("tr[name=NTONRelationNDayExeTime]").show().find("td.tdlabel").html("持续"+value+"天后执行时间")
				$("tr[name=cxjgzq]").show().find("td.tdlabel").html("持续"+value+"天后间隔")
			}
	    });*/
		
		if(!isUndefined(obj.watchback)){
			//debugger
			$("#"+obj.id).watch(function(value,oldval,ele) {
		    	var id=$(ele).attr("id")
		    	eval("watch"+id+"(value)")
			
			})
		}
		
		
		if(!isUndefined(obj.reminder)){
			$("#"+obj.id+"_tip").popover({
				trigger:'hover',
				content:obj.reminder,
				style:'inverse'
			});
		}
		
		if(childs.length>0){
			for(var m=0;m<childs.length;m++){
				rsInputType(childs[m])
			}
		}else{
			rsInputType(obj)
		}
		
	}
	if(loadStyle==0){
		$('<style>.xctable{padding-top:10px;} .xctable td{padding-bottom:7px;white-space: nowrap;} .tdlabel{width:10px;padding-right:0px;white-space: nowrap;text-align:right;} .ant-form-item{padding-left: 10px;padding-right: 10px;}  .ant-form-item-required:before {display: inline-block;margin-right: 4px;color: #f5222d;font-size: 14px;font-family: SimSun,sans-serif;line-height: 1;content: "*";} </style>').appendTo('head')
		

		
		loadStyle=1
	}
}
var loadStyle=0


function createInputHtmlBak(contorlsId,pid,isAppend){
	for(var i=0;i<xcContors.length;i++){
		var obj = xcContors[i]
		
		if(!isUndefined(obj.pid)){
			continue;
		}
		
		//取控件信息
		var id = obj.id
		if(!isUndefined(contorlsId) && contorlsId!=""){
			if(id!=contorlsId){
				continue
			}
		}
		//判断界面中是否存在contorlsId控件
		var contorlen=$("tr[name="+contorlsId+"]").length
		if(contorlen>0){
			continue;
		}
		//取控件的子控件
		var childs=[]
		for(var j=0;j<xcContors.length;j++){
			if(!isUndefined(xcContors[j].pid)){
				if(id==xcContors[j].pid){
					childs.push(xcContors[j])
				}
			}
		}
		
		var tds=[]
		if(childs.length>0){
			for(var m=0;m<childs.length;m++){
				tds.push(rsInputHtml(childs[m]))
			}
		}else{
			tds.push(rsInputHtml(obj))
		}
		var requiredHtml=""
		if(!isUndefined(obj.required)){
			requiredHtml='<label class="ant-form-item-required" style="white-space: nowrap;">'
		}
		
		
		var vsReminder=""
		if(!isUndefined(obj.reminder)){
			$(".vsReminder").find("a.hisui-linkbutton").attr("id",obj.id+"_tip")
			var vsReminder = $(".vsReminder").html()
		}
		var title=""
		if(obj.title!=""){
			title=obj.title+":"
		}
		var html='<tr name="'+obj.id+'">'+
		   '<td class="tdlabel">'+requiredHtml+title+'</label></td>'+
		   '<td>'+tds.join("")+vsReminder+'</td>'+
		   '</tr>'
	   if(isUndefined(pid)){
		   $("#condion").append(html)
		}else{
			$("#"+pid).parents("tr").after(html)
		}
		
		if(isUndefined(isAppend)){
			$("#"+pid).append(html)
		}
		
		
		
		if(!isUndefined(obj.reminder)){
			$("#"+obj.id+"_tip").popover({
				trigger:'hover',
				content:obj.reminder,
				style:'inverse'
			});
		}
		
		if(childs.length>0){
			for(var m=0;m<childs.length;m++){
				rsInputType(childs[m])
			}
		}else{
			rsInputType(obj)
		}
		
	}
}

	function isUndefined(value){
		return typeof(value) =="undefined"
	}
	function rsInputType(obj){
		
		if(isUndefined(obj.classMethod)){
			obj.classMethod="Nur.NIS.Service.NursingTask.TaskOptions"
		}
		var type=obj.type
		if((type=='comboxGrid')||(type=='combox')){
			var classMethod=obj.classMethod
			var queryName=obj.queryName
			var data=obj.objData
			if(isUndefined(data)){
				if(isUndefined(classMethod) || isUndefined(queryName) || isUndefined(type)){
					return
				}
				
				
				if(type=='comboxGrid'){
					getComboxGridData(obj)
				}
				if(type=='combox'){
					getComboxData(obj)
				}
			}else{
				if(type=='comboxGrid'){
					getComboxGridData(obj)
				}else{
					getComboxLocalData(obj)	
				}
				
			}
		}else if(type=="text"){
			if(!isUndefined(obj.defaultValue)){
				$("#"+obj.id).val(obj.defaultValue)
			}	
		}else if(type=="color"){
			if(!isUndefined(obj.defaultValue)){
				$("#"+obj.id).val(obj.defaultValue)
			}
			$("#"+obj.id).attr("type","color")
		 	$("#"+obj.id).color({
				editable:true,
				required:true,
				width:110,
				height:30
			});
			
				
		}else if(type=="timebox"){
			$("#"+obj.id).val(obj.defaultValue)
			$('#'+obj.id).timeboxq({
			value: '11:11:11',
			});
		}
		
		
		
		
		
	}
	var xcChange={}
	function getComboxLocalData(obj){
		var $this = combox(obj.id)
		var data={"data":obj.objData}
		if(!isUndefined(obj.multiple)){
			if(obj.multiple==true || obj.multiple=="true"){
				data.multiple=obj.multiple
				data.rowStyle='checkbox'
			}
		}
		
		if(!isUndefined(xcChange)){
			if(!isUndefined(xcChange[obj.id])){
				data.onChange=xcChange[obj.id]
			}
		}
		if(!isUndefined(obj.onSelect)){
			data.onSelect=obj.onSelect
		}
		if(!isUndefined(obj.onChange)){
			data.onChange=obj.onChange
		}
		
		$this.combobox(data)
		if(!isUndefined(obj.defaultValue)){
			if(obj.defaultValue!=""){
				if(isUndefined(obj.multiple)){
					$this.combobox("setValue",obj.defaultValue)
				}else{
					var values =obj.defaultValue.split(",")
					$this.combobox("setValues",values)
				}
				if(!isUndefined(obj.onSelect)){
					
					if(typeof(eval(obj.onSelect))=="function"){
						var TextValue={
						value:$("#"+obj.id).combobox("getValue"),
						text:$("#"+obj.id).combobox("getText")
						}
						obj.onSelect(TextValue)
					}
				}
			
			}
		}

			
		
	}
	function getComboxData(obj){
		var classMethod=obj.classMethod
		var queryName=obj.queryName
		var $this = combox(obj.id)
		
		runClassMethod(classMethod,queryName,{},function(data){
			//console.log(data)
			var data={"data":data}
			if(!isUndefined(obj.multiple)){
				if(obj.multiple==true || obj.multiple=="true"){
					data.multiple=obj.multiple
					data.rowStyle='checkbox'
				}
			}
			
			if(!isUndefined(xcChange[obj.id])){
				data.onChange=xcChange[obj.id]
			}
			$this.combobox(data)
			if(!isUndefined(obj.defaultValue)){
				if(isUndefined(obj.multiple)){
					$this.combobox("setValue",obj.defaultValue+"")
				}else{
					var values =obj.defaultValue.split(",")
					$this.combobox("setValues",values)
				}
			}
	
			
		},'json',false);	
		
	}
	
	function rsInputHtml(obj){
		var css="",placeholder="",value="",isDisabled=""
		if(!isUndefined(obj.style)){
			css=obj.style;
		}
		if(!isUndefined(obj.placeholder)){
			placeholder=obj.placeholder
		}
		if(!isUndefined(obj.isDisabled)){
			isDisabled=obj.isDisabled
		}
		var html=""
		if(!isUndefined(obj.type)){
			html= html+'<input id="'+obj.id+'" placeholder="'+placeholder+'" '+isDisabled+'  name="'+obj.id+'" type="text" class="textbox hisui-validatebox" style="'+css+'">'
			
			if(obj.type=="timebox"){
				html= '<input id="'+obj.id+'" placeholder="'+placeholder+'" '+isDisabled+'  name="'+obj.id+'" type="text" class="hisui-timeboxq textbox" data-options="timeFormat:\'HMS\'" style="'+css+'">'
			
			}
		}
		 
		return html
	}
	


var contorls={
	
}



var createHtml={
	input:function(obj){
		var desc = obj.desc
		var arrs = obj.childs
		var required=obj.required
		
		var tds=[]
		for(var i=0;i<arrs.length;i++){
			var id=arrs[i].id
			var styles=arrs[i].style
			var css=""
			if(typeof(styles) !="undefined"){
				for(var key in styles){
					var value=styles[key]
					css=css+key+":"+value+";"
				}
			}
			if(css==""){
				css="width:300px;"
			}
			var html= '<input id="'+id+'" name="'+id+'" type="text" class="textbox hisui-validatebox" style="'+css+'">'
			//html =html+'<a href="#" id="'+obj.id+'_tip" class="hisui-linkbutton" data-options="iconCls:\'icon-tip\',plain:true"></a>'
			var vsReminder = $(".vsReminder").html()
			html=html+vsReminder
			tds.push(html)
		}
		
		var requiredHtml="<label>"
		if(typeof(required) !="undefined"){
			requiredHtml='<label class="ant-form-item-required" style="white-space: nowrap;">'
		}
		var html='<tr>'+
		   '<td class="tdlabel">'+requiredHtml+desc+'</label></td>'+
		   '<td>'+tds.join("")+'</td>'+
		   '</tr>'
		return html
	},
	combox:function(desc,id,url){
		var html=create.input(desc,id)
		
		return html
	}
	
}



function combox(selector){
	$HUI.combo("#"+selector,{
		valueField:"value",
		textField:"text",
		multiple:false,
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false
	});	
	$("#"+selector).siblings("span.combo").css({"position": "relative"})
	$("#"+selector).siblings("span.combo").find("span.combo-arrow").css({"position": "absolute","right":"1px"})

	return $("#"+selector)
}
function getComboxGrid(selector,className,queryName,multiple){
	var obj={
		"id":selector,
		"classMethod":className,
		"queryName":queryName,	
		"multiple":multiple
	}
	getComboxGridData(obj)
}
function getCombox(selector,className,queryName,multiple){
	var obj={
		"id":selector,
		"classMethod":className,
		"queryName":queryName,	
		"multiple":multiple
	}
	getComboxData(obj)
}


function getComboxGridData(obj){
	var selector=obj.id
	var className=obj.classMethod
	var queryName=obj.queryName
	var filterData=obj.filterData
	var searchhtml = $("#comboxSearch").html()
	var len = $('#'+selector+"-search").length
	var id = selector+"-search"
	if(len==0){
		var html = '<div style="margin-bottom: 5px;display:none " class="searchBtn" id="'+id+'">'+searchhtml+'</div>'
		$("#comboxSearch").after(html)
		$("#"+id).find(".startDayReport").addClass(selector+"-startDayReport")
		if(!isUndefined(obj.placeholder)){
			$("#"+id).find(".startDayReport").each(function(){
				$(this).attr("placeholder",obj.placeholder)
			})
		}
	}
	
	var defalutColumns=[[{field:'desc',title:'名称',width:350}]]
	if(!isUndefined(obj.columns)){
		defalutColumns=[obj.columns]
	}
	var ins=0
	
	$("#"+selector).combogrid({
			panelHeight: 350,
			editable: false,
			idField: 'id',
			textField: 'desc',
			columns: defalutColumns,
			pagination : true,
			url:$URL+"?ClassName="+className+"&QueryName="+queryName,
			toolbar: '#'+selector+"-search",
			fitColumns: true,
			pageSize:50,
			multiple: true,
			striped: true,
			mode:"remote",
			loadFilter: function(objData) {
			  //过滤掉列表中已选择的行
			  var arrs = []
			  $.each(objData.rows, function(index, value) {
	                var $div = $("#"+selector).siblings("span.combo").find("div.div-combo-text")
					var len = $div.find('span[id="'+value.id+'"]').length
	                if(len==0){
		                
		                if(!isUndefined(filterData)){
		        	  		if(filterData.indexOf(value.id)<0){
			        	  		arrs.push(value)
			        	  	}
		        		}else{
			        		arrs.push(value)	
			        	}
		             }
	                
	            });
	            if(ins==0 && objData.rows.length==0){
		            arrs=obj.objData
		        }
	            console.log(arrs)
			  objData.rows = arrs
			  return objData;
			},
			
			onBeforeLoad: function(data) {
			
				$("#"+selector).combogrid('grid').datagrid('clearSelections');
			},
			onBeforeLoad: function(param) {
				//初始化入参
				var desc =$("."+selector+"-startDayReport").val()
				if(!isUndefined(obj.searchKey)){
					var searchParma={}
					searchParma[obj.searchKey]=desc
					param = $.extend(param,searchParma)
				}else{
					param = $.extend(param,{desc:desc,"hospID":hospId})
				}
				
				
				
			},
			onLoadSuccess:function(rowData){
				ins=1
				//debugger;
				//console.log(rowData)
				
				//var rows = $('#'+selector).combogrid('grid').datagrid('getRows');
				//console.log(rows)
				//	console.log(rowData)
				
				$("#"+selector).combogrid('grid').datagrid('clearSelections');
				
				/*if(!isUndefined(obj.defaultValue)){
					var values=obj.defaultValue
					values = values.split(",")
					for(var i=0;i<rowData.rows.length;i++){
						var id = rowData.rows[i].id
						var desc = rowData.rows[i].desc
						if(values.indexOf(id)>-1){
							insertComboDiv(obj,id,desc)
						}
					}					
				}*/
				
				
			},
			onClickRow:function(rowIndex, rowData){
				var desc = rowData.desc
				var id = rowData.id	
				var comboparmas={}
				if(!isUndefined(obj.insertKey)){
					//var a={"keyname":"","valname":""}
					var keyName=obj.insertKey.keyname
					var valueName=obj.insertKey.valname
					
					id=rowData[keyName]
					desc=rowData[valueName]
					
				}else{
					comboparmas.id= rowData.id	
					comboparmas.desc
				}
				
				insertComboDiv(obj,id,desc)
				if(!isUndefined(obj.callback)){
					eval(obj.callback+"(rowData)")
				}
				
			}
		});	
		
	
		
		
		if(!isUndefined(obj.defaultValue) && "" !=obj.defaultValue && null != obj.defaultValue){
			var values=obj.defaultValue
			values = values.split("^")
			for(var j=0;j<values.length;j++){
				var id = values[j].split("@")[0]
				var desc = values[j].split("@")[1]
				insertComboDiv(obj,id,desc)
			}
		}
		/*var trObj = $HUI.combogrid("#"+selector);
        var grid = trObj.grid();
		grid.datagrid("loadData",{"total":5,"rows":[
            {"episodeID":"EST-1","cname":"Koi","listprice":36.50,"unitcost":10.00,"attr1":"Large","status":"P"},
            {"episodeID":"EST-10","cname":"Dalmation","listprice":18.50,"unitcost":12.00,"attr1":"Spotted Adult Female","status":"P"},
            {"episodeID":"EST-11","cname":"Rattlesnake","listprice":38.50,"unitcost":12.00,"attr1":"Venomless","status":"P"},
            {"episodeID":"EST-12","cname":"Rattlesnake","listprice":26.50,"unitcost":12.00,"attr1":"Rattleless","status":"P"},
            {"episodeID":"EST-13","cname":"Iguana","listprice":35.50,"unitcost":12.00,"attr1":"Green Adult","status":"P"}
        ]});*/
		
		$("#"+selector).siblings("span.combo").css({"position": "relative"})
		$("#"+selector).siblings("span.combo").find("span.combo-arrow").css({"position": "absolute","right":"1px"})
		$("#"+selector).siblings("span.combo").find("input.combo-text").hide()
		$("body").on("click",".btnTaskSearch",function(){
			var id = $(this).parents(".searchBtn").attr("id")
			var gridId=id.split("-")[0]
			console.log(gridId)
			$('#'+gridId).combogrid("grid").datagrid("load");	
		})
}


//点击下拉列表时事件
function insertComboDiv(obj,id,desc){
	var selector= obj.id;
	var $input = $("#"+selector).siblings("span.combo").find("input.combo-text")
	var w = $input.width()
	var h = $input.height()
	$input.hide()
	//$("#"+selector).siblings("span.combo").find("span.combo-arrow").hide()
	$("#"+selector).siblings("span.combo").css({"white-space":"normal","height":"auto"})

	var len = $("#"+selector).siblings("span.combo").find(".div-combo-text").length;
	if(len==0){
		$input.after('<div class="div-combo-text" style="display: inline-block;padding-bottom:5px;border:0px solid;width:100%;min-height:'+h+'px;"></div>')
		$("#"+selector).siblings("span.combo").find(".div-combo-text").on("click",function(event){
			event.stopPropagation()
			$input.trigger("click")
		})
	}
	
	var $div = $("#"+selector).siblings("span.combo").find("div.div-combo-text")
	var $divlen = $div.find('span[id="'+id+'"]').length
	if($divlen==0){
		var sHtml='<span style="background-color: #fafafa;border-radius: 2px;padding-left: 3px;padding-right: 20px;border: 1px solid #e8e8e8;display: inline-block;margin: 5px 0px 0px 5px;position: relative;" id="'+id+'">'+desc+'<a style="width: 16px;height: 16px;display: inline-block;vertical-align: top;position: absolute;right:1px;top:1px" class="panel-tool-close" href="javascript:void(0)"></a></span>'
		if(isUndefined(obj.multiple)){
			$div.html(sHtml)
		}else{
			if(obj.multiple=="true"){
				$div.append(sHtml)
			}else{
				$div.html(sHtml)	
			}
			
		}
		$div.find("span a.panel-tool-close").on("click",function(event){
			debugger;
			event.stopPropagation()
			$(this).parent().remove()
			var values=[]
			var $div = $("#"+selector).siblings("span.combo").find("div.div-combo-text")
			$div.find('span').each(function(){
				var val = $(this).attr("id")
				values.push(val)
			})
			value= values.join(",")
			obj.defaultValue=value
			$('#'+selector).combogrid("grid").datagrid("load");	
			
			
		})
	}
	$('#'+selector).combogrid("grid").datagrid("load");
	
}
function runClassMethodNewBak(className,methodName,datas,successHandler,datatype,async){
	var opt;
	datas = datas||{};
	if(datas.IsQuery){
		opt = {ClassName:className,QueryName:methodName};
		$.extend(opt,datas);
		if (typeof async=='undefined' || async){
			$cm(opt,successHandler);
		}else{
			return successHandler.call(this,$cm(opt,false));
		}
	}else {
		if (arguments.length>4){
			opt = {ClassName:className,MethodName:methodName,dataType:datatype==''?'text':datatype};
		}else{
			opt = {ClassName:className,MethodName:methodName};
		}
		$.extend(opt,datas);
		if (typeof async=='undefined' || async){
			$cm(opt,successHandler);
		}else{
			return successHandler.call(this,$cm(opt,false));
		}
	}
}


function runClassMethodNew(className,methodName,datas,successHandler,datatype,async){
	var opt;
	datas = datas||{};
	if(datas.IsQuery){
		opt = {ClassName:className,QueryName:methodName};
		$.extend(opt,datas);
		if (typeof async=='undefined' || async){
			$cm(opt,successHandler);
		}else{
			return successHandler.call(this,$cm(opt,false));
		}
	}else {
		if (arguments.length>4){
			opt = {ClassName:className,MethodName:methodName,dataType:datatype==''?'text':datatype};
		}else{
			opt = {ClassName:className,MethodName:methodName};
		}
		$.extend(opt,datas);
		if (typeof async=='undefined' || async){
			$cm(opt,successHandler);
		}else{
			return successHandler.call(this,$cm(opt,false));
		}
	}
}
