CompObj.cls = "web.DHCEventModel";
CompObj.compName = "DHCEventModel";
CompObj.tabelPre = "Model";
CompObj.model = ["RowId","Code", "Desc", "Active","FiledSet","Note","Type"];
CompObj.modelUi=["","","",
	{type:"combobox",data:[{Code:"Y",Desc:"激活"},{Code:"N",Desc:"不激活"}]},
	"","",
	{type:"combobox"}
];
///重写saveClick
var saveClick = function(){
	if (CompObj.modelObj["Code"] && CompObj.modelObj["Code"].val()==""){
		$.messager.alert(t['Warning'],t['CodeRequire']);return false;
	}
	if (CompObj.modelObj["Desc"] && CompObj.modelObj["Desc"].val()==""){
		$.messager.alert(t['Warning'],t['DescRequire']); return false;
	}
	//
	if (CompObj.modelObj["Type"]){
		var TypeValue=CompObj.modelObj["Type"].combobox('getValue');
		var TypeData=CompObj.modelObj["Type"].combobox('getData');
		var TypeFlag=false;
		$.each(TypeData,function(){
			if (this.Code==TypeValue || this.Desc==TypeValue){
				TypeFlag=true;
				return false;	
			}	
		})
		if (!TypeFlag) {
			$.messager.alert(t['Warning'],"请选择正确的类型"); return false;
		}
	}
	if (CompObj.modelObj["Active"]){
		var ActiveValue=CompObj.modelObj["Active"].combobox('getValue');
		if (ActiveValue!="Y") CompObj.modelObj["Active"].combobox('setValue',"N");
	}
	$.ajaxRunServerMethod(getModelJson("Save"),
		function(data,textStatus){
			if ("undefined" == typeof data.err){
				if (data>0){
					$.messager.alert('成功','保存成功');
					$("#Clear").click();
					$("#Find").click();
				}else{
					$.messager.alert(t['Fail'],t['SaveFail']+"&nbsp;&nbsp;"+(t[data]||data));  
				}
			}else{
				$.messager.alert(t['Fail'],t['SaveFail']+"&nbsp;&nbsp;"+data.err);  
			}
		}
	);
}
function initBody(){
	$.ajaxRunServerMethod({ClassName:"web.DHCEventModel",MethodName:"GetTypeJson"},
		function(data,textStatus){
			if(""!==data){
				CompObj.modelUi[6].data = $.parseJSON(data);
				initEvent();
			}
		}
	);

	
}
function init (){
	initBody();
	resizeGrid();
}
function resizeGrid(){
	var h = $(window).height();
	var offset = $('#tDHCEventModel').closest('.datagrid').offset();
	$('#tDHCEventModel').datagrid("resize",{height:parseInt(h-offset.top)});
}
$(init)
