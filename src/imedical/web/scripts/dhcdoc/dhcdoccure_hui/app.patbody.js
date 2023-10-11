$(document).ready(function(){
	Init();
	InitEvent();
	PageHandle();
	//LoadCureBodyPointDataGrid();
})

var PatBodyObj={
	imagLoacation:"",
	CureBodyPointDataGrid:"",
	wid:440,
	heit:440,
	_body_drawUtil:"",
	CurHandleCanvasId:"",
	UpdateFlag:""
}

$(window).load(function(){
	InitCanvas();
})

function Init(){
	showPatBody(ServerObj.Sex);
	PatBodyObj.CureBodyPointDataGrid=InitCureBodyPointDataGrid();
}

function InitEvent(){
	$("#btnSaveBody").click(function(e){
        //SaveBody();
        SaveBodyImage();
    })
}

function PageHandle(){
	if(ServerObj.ApplyStatus=="F"){
		$("#btnSaveBody").linkbutton("disable");
		$("#btnSaveBody").unbind();
		$(".canvas-tool-item").removeClass("active").addClass("img-gray");
	}	
}

function InitCanvas(){
	var ret=$.cm({
		ClassName:"DHCDoc.DHCDocCure.BodySet",
		MethodName:"GetBodySet",
		dataType:"text",
		'DCARowId':ServerObj.DCARowId
	},false); 
	var retObj=JSON.parse(ret);
	var BodyImage=retObj.BodyImage;
	var BodySetStr=retObj.BodySetStr;
	if(BodySetStr!=""){
		PatBodyObj.UpdateFlag="Y";
		addBodyImage(BodyImage);
		LoadCureBodyPointDataGrid(BodySetStr);
	}
	
	if(ServerObj.PatSex == "女"){
        var bodyImage="../scripts/dhcdoc/dhcdoccure_hui/image/famale.png";
    }else{//如果不是女则显示为男
        var bodyImage="../scripts/dhcdoc/dhcdoccure_hui/image/male.png";
    }
    InitBodyCanvas(bodyImage)
	
	layui.use('colorpicker', function() {
		var colorpicker = layui.colorpicker;
		colorpicker.render({
			elem:'#colors',
			color:'#ff0000', //初始化需要用#ff0000的格式实际选择的和下方输入框里显示的“#000000”黑色
			done:changeColor,
			predefine: true,
            colors: ['#F00','#0F0','#000','#00F'],
            size:'sm'
		});
	});
}

function changeColor(color){
	if(color==""){
		$.messager.popover({msg: '请选择颜色！',type:'alert',timeout: 1500,
		style:{
			top:document.body.scrollTop + document.documentElement.scrollTop+10,
			right:$(window).width()*0.5-50
		}});
		return false;	
	}else{
		PatBodyObj._body_drawUtil.penColor(color);
	}
}

function InitBodyCanvas(imgsrc){
	PatBodyObj._body_drawUtil=new DrawingTools();
	PatBodyObj._body_drawUtil.init({'id':'body-pic-diagonal-c0','dataGrid':PatBodyObj.CureBodyPointDataGrid})
	PatBodyObj._body_drawUtil.begin(1);//默认线条
}

function changeMode(obj,mode){
	if(mode==-1){
		if(ServerObj.ApplyStatus=="F"){
			$.messager.popover({msg: '该治疗申请已完成,无法重绘!',type:'alert',timeout: 1500});
			return false;	
		}
		if($('#body_img').length>0){
			removeBodyImage();
		}else{
			cleatAllCanvas();
		}
	}else if(mode==0){
		if(PatBodyObj.CurHandleCanvasId!=""){
			var CurHandleCanvasId=PatBodyObj.CurHandleCanvasId;
			removeHandleCanvas(CurHandleCanvasId)
		}else{
			
		}
	}else{
		PatBodyObj._body_drawUtil.begin(mode);
		$(".canvas-tool-item").removeClass("active");
    	$(obj).addClass('active');
	}
}

///清除所有画布内容
function cleatAllCanvas(){
	$.messager.confirm("提示","是否确认重绘?",function(r){
		if(r){
			var len=$("#body-pic").children('canvas').length;
			for(var i=len;i>2;i--){
				var lastObj=$("#body-pic").children("canvas:last-child");
			    if(($(lastObj).hasClass("canvas-diagonal"))||($(lastObj).hasClass(".canvas-diagonal"))){
			    	$(lastObj).remove();
			    }	
		    }

		    var s=PatBodyObj._body_drawUtil.reInit({'id':"body-pic-diagonal-c0",'dataGrid':PatBodyObj.CureBodyPointDataGrid,'paintCount':1})
		    if(s){
			    PatBodyObj._body_drawUtil.clear();
			}

			delGridData("");
		}
	})
}

function removeHandleCanvas(CurHandleCanvasId){
	var id=CurHandleCanvasId.split("-").slice(0,2).join("-");
	var lastObj=$("#"+id).children("canvas:last-child");
	
	var len=$("#"+id).children('canvas').length;
	
	//先移除最上层的空白画布，再清除下一层画布内容，并将下下一层画布设为正在操作画布
	//若只剩两层画布，则直接清除当前画布
    if(($(lastObj).hasClass("canvas-diagonal"))||($(lastObj).hasClass(".canvas-diagonal"))){
	    if(len>2){
    		$(lastObj).remove();
		}else{
			return true;	
		}
	    var s=PatBodyObj._body_drawUtil.reInit({'id':CurHandleCanvasId,'dataGrid':PatBodyObj.CureBodyPointDataGrid})
	    if(s){
		    PatBodyObj._body_drawUtil.clear();
		    delGridData(CurHandleCanvasId);
		}
		
    }	
}

function removeBodyImage(){
	$.messager.confirm("提示","是否确认重绘?",function(r){
		if(r){
			$("#body-pic").find("img[id='body_img']").remove();
			delGridData("");
			PatBodyObj.UpdateFlag="";
			var ret=$.cm({
				ClassName:"DHCDoc.DHCDocCure.BodySet",
				MethodName:"UpdateBodySet",
				dataType:"text",
				'DCARowId':ServerObj.DCARowId,
				'BodyStr':"",
				ClearFlag:"Y"
			},false); 
		}	
	})
}
function addBodyImage(BodyImage){
    var bodyImg = 
    	'<img id="body_img" src="" class="body-img" />'
	$('#body-pic').append(bodyImg);
	document.getElementById('body_img').setAttribute("src", BodyImage);
}

function showPatBody(PatSex){
    var AreaHtmlStr=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		MethodName:"GetCureBodyConfig",
		BodyImageId:"",
		dataType:"text"
    },false);
    var AreaHtmlObj=JSON.parse(AreaHtmlStr); 
    var FFAreaHtmlStr=AreaHtmlObj.femalefrontpic || "";
    var FBAreaHtmlStr=AreaHtmlObj.femalebackpic || "";
    var MFAreaHtmlStr=AreaHtmlObj.malefrontpic || "";
    var MBAreaHtmlStr=AreaHtmlObj.malebackpic || "";
    //通过性别加载图片
    if(PatSex == "女"){
        var bodyImag="../scripts/dhcdoc/dhcdoccure_hui/image/famale.png";
        var frontAreaHtmlStr=FFAreaHtmlStr;
        var backAreaHtmlStr=FBAreaHtmlStr;
    }else{//如果不是女则显示为男
        var bodyImag="../scripts/dhcdoc/dhcdoccure_hui/image/male.png";
        var frontAreaHtmlStr=MFAreaHtmlStr;
        var backAreaHtmlStr=MBAreaHtmlStr;
    }
    
    var body = 
        '<img id="body_img_little" usemap="#littlebodymap" class="body-img" src="'+bodyImag+'"/>'+
        '<map id="littlebodymap" name="littlebodymap">'+
            backAreaHtmlStr+  
        '</map>'
    
    var bcanvers = document.getElementById("body-pic-bg");
    var bctx = bcanvers.getContext("2d");
	var bimg = new Image();
    bimg.src = bodyImag;
    // 等待加载完成再绘制
    bimg.onload = function(){
        bctx.drawImage(bimg, 0,0,PatBodyObj.wid,PatBodyObj.heit);
    }
    return;
}
/**
 * 选中人体部位，高亮显示
 * @param {*} id 画布id
 * @param {*} objs 人体对象id数组（男女）
 */
function showBodyDetail(id,objs){
    var canvers = document.getElementById(id);
    var context = canvers.getContext("2d");
    context.clearRect(0, 0, canvers.width, canvers.height);
    var strs = new Array(); //定义一数组
    
       
    context.fillStyle = "#FF0000";
    context.font = "15px serif";
    
    for(var j = 0; j < objs.length; j++){
	    var StartXPoint=0;
    	var StartYPoint=0;
        strs = $(objs[j]).attr("coords").split(",");//选择部位的坐标
        var id = $(objs[j]).attr("id");
        id=id.split("_")[1];
        //使用画布描出坐标
        var i1, i2;
        for (var i = 0; i < strs.length; i++) {
            if (i % 2 == 0) {
                i1 = strs[i];
                StartXPoint=i1;
            }
            if (i % 2 == 1) {
                i2 = strs[i];
                StartYPoint=i2;
                if (i == 1) {
                    context.moveTo(i1, i2);
                }
                else {
                    context.lineTo(i1, i2);
                }
            }
        } 
        context.globalAlpha = 1; 
        context.strokeText(id, StartXPoint, StartYPoint);
    }
    context.globalAlpha = 0.2; 
    context.fill();
    context.closePath(); //闭合
    
}

function InitCureBodyPointDataGrid(){
	var mt = [
		{
	        text: '删除',
	        iconCls: 'icon-remove',
	        handler: function() {
				delBodyPointData();
	        }
	    }
	]
	var CureBodyPointDataGrid=$('#CureBodyPointDataGrid').datagrid({  
		fit : true,
		width : 'auto',
		url : '',
		border : false,
		striped : true,
		singleSelect : true,
		checkOnSelect:true,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: true,
		collapsible:false,
		loadMsg : '加载中..',  
		pagination : false,
		rownumbers : true,
		idField:"Id",
		//pageSize : 10,
		//pageList : [10,20],
		columns :[[ 
			{field:'BodyImage',title:'所属图片',width:10,align:'left', hidden: true},
			{field:'Id',title:'部位序号',width:80,align:'left', resizable: true},  
			{field:'BodyImageId',title:'所属图片Id',width:10,align:'left', hidden: true,sortable:true},
			{field:'BodyPointDesc',title:'部位描述',width:150,align:'left', resizable: true,editor : {type : 'text',options : {}}},
			{field:'BodyPointValue',title:'部位像素点值',width:400,align:'left', hidden: true},
			{field:'BodyNote',title:'部位备注',width:300,align:'left', hidden: false,editor : {type : 'text',options : {}}}
		]],
		//toolbar:mt,
		onDblClickRow:function(rowIndex, rowData){
			showRowBodyDetail(rowData);
			var BodyImage=rowData.BodyImage;
		},
		onClickRow:function(rowIndex, rowData){
     		rowIndexFocus(rowIndex,"BodyPointDesc");
		}
	});
	return CureBodyPointDataGrid;	
}

function rowIndexFocus(rowIndex,field){
	PatBodyObj.CureBodyPointDataGrid.datagrid("beginEdit", rowIndex);
	var editor = PatBodyObj.CureBodyPointDataGrid.datagrid('getEditor', {index:rowIndex,field:field});
	editor.target.focus();	
}

function delBodyPointData(){
	var row = PatBodyObj.CureBodyPointDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一条需要删除的记录","warning");
		return false;
	}
	
	$.messager.confirm("提示","是否确认删除?",function(r){
		if(r){
			delGridData(row.BodyImageId);
		}	
	})
}

function delGridData(CanvasId){
	if(CanvasId==""){
		PatBodyObj.CureBodyPointDataGrid.datagrid('loadData',{total: 0, rows: []});
	}else{
		var findIndex=-1;
		var ListData = PatBodyObj.CureBodyPointDataGrid.datagrid('getData');
		for (i=0;i<ListData.total;i++){
			if(ListData.rows[i].BodyImageId==CanvasId){
				findIndex=i
				break;
			}
		}
		if(findIndex>-1){
			PatBodyObj.CureBodyPointDataGrid.datagrid('deleteRow',findIndex);
		}
	}
}

function LoadCureBodyPointDataGrid(BodySetStr){
	if ("undefined"==typeof BodySetStr){BodySetStr="";}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"QueryCureBody",
		BodyImageId:"",
		Sex:ServerObj.Sex,
		BodySetStr:BodySetStr
	},function(GridData){
		//PatBodyObj.CureBodyPointDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		$HUI.datagrid('#CureBodyPointDataGrid',{
		    data:GridData
		});
	})	
}

function showRowBodyDetail(rowData){
	var BodyImageIdArr=rowData.BodyImageId.split("-");
	var BodyImageId=BodyImageIdArr[1]+"-"+BodyImageIdArr[2]+"-diagonal";
	var BodyPointValue=rowData.BodyPointValue;
	BodyPointValue=BodyPointValue.replace(/@/g,",");
	var canvers = document.getElementById(BodyImageId);
	var context = canvers.getContext("2d");
	//context.clearRect(0, 0, canvers.width, canvers.height);
	var strs = new Array(); //定义一数组
	context.beginPath();
	strs = BodyPointValue.split(",");//选择部位的坐标
	//使用画布描出坐标
	var i1, i2;
	for (var i = 0; i < strs.length; i++) {
	    if (i % 2 == 0) {
	        i1 = strs[i];
	    }
	    if (i % 2 == 1) {
	        i2 = strs[i];
	        if (i == 1) {
	            context.moveTo(i1, i2);
	        }
	        else {
	            context.lineTo(i1, i2);
	        }
	    }
	}
	context.globalAlpha = 0.6;  
	context.fillStyle = "#FF0000";
	//context.clearRect(0, 0, 350, 700);
	context.fill();
	//context.closePath(); //闭合	
}

function SaveBodyImage(){
	var BodyArr=new Array();
	var RetBodyArr=new Array();
	var rows=PatBodyObj.CureBodyPointDataGrid.datagrid("getRows");
	if (rows.length > 0){ 	
		var bk=true;
		for (var i = 0; i < rows.length; i++) {
			var BodyImage=rows[i].BodyImage;
			var Id=rows[i].Id;
			var BodyImageId=rows[i].BodyImageId;
			var editors = PatBodyObj.CureBodyPointDataGrid.datagrid('getEditors', i); 
			var preMsg=$g("第");
			if(editors.length>0){
				var BodyPoint=editors[0].target.val();
				if(BodyPoint==""){
					$.messager.alert("提示",preMsg+(i+1)+$g("行请填写部位描述"),"warning",function(){
						editors[0].target.focus();	
					});
					bk=false;
					break;	
				}
				var BodyNote=editors[1].target.val();
				if(BodyNote==""){
					$.messager.alert("提示",preMsg+(i+1)+$g("行请填写部位备注"),"warning",function(){
						editors[1].target.focus();	
					});
					bk=false;
					break;	
				}
			}else{
				var BodyPoint=rows[i].BodyPointDesc;
				if(BodyPoint==""){
					$.messager.alert("提示",preMsg+(i+1)+$g("行请填写部位描述"),"warning",function(){
						rowIndexFocus(i,"BodyPointDesc")
					});
					bk=false;
					break;	
				}
				var BodyNote=rows[i].BodyNote;
				if(BodyNote==""){
					$.messager.alert("提示",preMsg+(i+1)+$g("行请填写部位备注"),"warning",function(){
						rowIndexFocus(i,"BodyNote")
					});
					bk=false;
					break;	
				}
			}
			var BodyStr=BodyImage+"$$$"+Id+"$$$"+BodyImageId+"$$$"+BodyPoint+"$$$"+BodyNote;
			BodyArr.push(BodyStr);
		}
		if(!bk){return}
		if(PatBodyObj.UpdateFlag=="Y"){
			var BodyStr=BodyArr.join("###");
			var ret=$.cm({
				ClassName:"DHCDoc.DHCDocCure.BodySet",
				MethodName:"UpdateBodySet",
				dataType:"text",
				'DCARowId':ServerObj.DCARowId,
				'BodyStr':BodyStr
			},false); 
			if(ret=="0"){
				$.messager.alert("提示","保存成功","info",function(){
					LoadCureBodyPointDataGrid(BodyStr);
				});
			}else{
				$.messager.alert("提示",$g("保存失败！错误代码:")+ret,"error");	
			}
		}else{
			var BodyDataURL=mergeCanvas("body-pic");
			
			var ret=$.cm({
				ClassName:"DHCDoc.DHCDocCure.BodySet",
				MethodName:"SaveBodySet",
				dataType:"text",
				_headers:{'X-Accept-Tag':1},
				'DCARowId':ServerObj.DCARowId,
				'BodyFrontImage':BodyDataURL,
				'BodyBackImage':"",
				'BodyStr':BodyArr.join("###")
			},false); 
			
			var ret=RetBodyArr.join(String.fromCharCode(13));
			websys_showModal("hide");
			if(websys_showModal('options')&&(websys_showModal('options').AddBodyNoteToPlan)){
				websys_showModal('options').AddBodyNoteToPlan(ret);
			}
			websys_showModal("close");
		}
	}else{
		$.messager.alert("提示", "未有编辑的行", "warning");
		return false;	
	}
}

function mergeCanvas(id){
	var canvasBg = document.getElementById(id+"-bg");
	var chobj=$("#"+id).children('canvas');
	for(var i=1;i<chobj.length;i++){
		var lastObj=chobj[i];
	    var blank=isCanvasBlank(lastObj);
	    if(blank){continue;}
	    canvasBg.getContext("2d").drawImage(lastObj,0,0);		
    }
    var DataURL=canvasBg.toDataURL();
    return DataURL;
    
    var DataURLArr=strSplitToArray(DataURL)
    //alert(DataURL.length)
    return DataURLArr;
}

function strSplitToArray(str){
	var size = 10000;
	if (str.length < size) {
        var rs = [];
        rs[0] = str;
        return rs
    } else {
        var count = Math.ceil(str.length / size)
        var rs = []
        for (var i = 0; i < count; i++) {
            if (i === 0) {
                rs.push(str.substring(i, size))
            } else if (i > 0 && i < (count-1)) {
                rs.push(str.substring((i * size), (i + 1) * size))
            } else {
                rs.push(str.substring((i * size), str.length))
            }
        }
        return rs;
    }
}

function isCanvasBlank(canvas) {
    var blank = document.createElement('canvas');
    blank.width = canvas.width;
    blank.height = canvas.height;

    return canvas.toDataURL() == blank.toDataURL();
}

    
function SaveBody(){
	var BodyArr=new Array();
	var rows=PatBodyObj.CureBodyPointDataGrid.datagrid("getRows");
	if (rows.length > 0){ 	
		for (var i = 0; i < rows.length; i++) {
			var editors = PatBodyObj.CureBodyPointDataGrid.datagrid('getEditors', i); 
			if(editors.length==0){
				continue;	
			}
			var BodyNote=editors[0].target.val();
			if(BodyNote==""){
				continue;	
			}
			var BodyDesc=rows[i].BodyPointDesc;
			BodyNote=BodyDesc+""+BodyNote;
			BodyArr.push(BodyNote);
		}
		var ret=BodyArr.join(String.fromCharCode(13));
		websys_showModal("hide");
		if(websys_showModal('options')&&(websys_showModal('options').AddBodyNoteToPlan)){
			websys_showModal('options').AddBodyNoteToPlan(ret);
		}
		websys_showModal("close");
	}else{
		$.messager.alert("提示", "未有编辑的行", "warning");
		return false;	
	}
}