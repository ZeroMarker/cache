document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js'></script>")
var LODOP; //声明为全局变量
var PrinterName=""; 
var init = function(){
		var myeditor = CKEDITOR.replace( 'edcontent', {
		width: "100%",
		height: "572",
		fit:true,
		//resize_dir: 'both',
		//resize_minWidth: 480,
		//resize_minHeight: 320,
		//resize_maxWidth: 818,	
					
					
		// Define the toolbar groups as it is a more accessible solution.
		toolbarGroups: [
			{"name":"basicstyles","groups":["basicstyles"]},
			{"name":"links","groups":["links"]},
			{"name":"paragraph","groups":["list","blocks"]},
			{"name":"document","groups":["mode"]},
			{"name":"insert","groups":["insert"]},
			{"name":"styles","groups":["styles"]},
			{"name":"about","groups":["about"]}
		],
		// Remove the redundant buttons from toolbar groups defined above.
		removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
			
	} );
	
	$("#Save").click(function(){
  			SaveEditorContent();
	});
	var iPAADM=$("#PAADM").val();
	var iPatientID=$("#PatientID").val();
	var iType=$("#Type").val();	
	$("#PrintView").click(function(){
  			PrintHealthGuide(iPAADM,iPatientID,iType,"V","");
	});
	$("#Print").click(function(){
  			PrintHealthGuide(iPAADM,iPatientID,iType,"P","");
	});
	ShowEditorContent();

}
/*help st
2、获取CKEditor纯文本
 var CText=CKEDITOR.instances.WORK_INTRODUCTION.document.getBody().getText(); //取得纯文本       

3、获取CKEditor带HTML标签的文本
var CHtml= CKEDITOR.instances.WORK_INTRODUCTION.getData();

4、给CKEditor赋值

CKEDITOR.instances.WORK_INTRODUCTION.setData("要显示的文字内容");


 end*/
function SaveEditorContent()
{	
	//CKEDITOR.instances.edcontent.getData中的edcontent是指textarea的name
	//var iedcontent=CKEDITOR.instances.edcontent.document.getBody().getText();
	var iedcontent= CKEDITOR.instances.edcontent.getData();
	var iPAADM=$("#PAADM").val();
	var iPatientID=$("#PatientID").val();
	var iType=$("#Type").val();
	
	if (iType=="HP"){
		var ret=tkMakeServerCall("web.DHCPE.HealthGuide","UpdateHGDetail",iPatientID,iedcontent);
	}
	else{
		var ret=tkMakeServerCall("web.DHCPE.HealthGuide","UpdateHGRecordDetail",iPAADM,iedcontent,iType);
	}
	if ((ret.split("^")[0])!=="-1"){$.messager.alert("提示","保存成功","info");}
	else{$.messager.alert("提示","保存失败","info");};
	
}
function ShowEditorContent()
{
	var iPAADM=$("#PAADM").val();
	var iPatientID=$("#PatientID").val();
	var iType=$("#Type").val();
	if (iType=="HP"){
		var iedcontent=tkMakeServerCall("web.DHCPE.HealthGuide","GetHGDetail",iPatientID);
	}
	else{
		var iedcontent=tkMakeServerCall("web.DHCPE.HealthGuide","GetHGRecordDetail",iPAADM,iType);
	}
	CKEDITOR.instances.edcontent.setData(iedcontent);

}

$(init);