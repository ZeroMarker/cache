///insu.imporexpport.js
var xlApp=null;
var xlBook=null;
var xlsheet=null;

function DestoryExcelObject(){
		xlBook.Close (savechanges=false);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
}
/// ����˵�����������ݹ�ͨjs����
/// ���˵����GlobalDataFlg --> ��ʱ���ݱ�־ 1 ���浽��ʱglobal���� 0 ���浽����(��Ҫ���������ͷ�����)
///                 UserDr           --> ����Ա
///                 ClassName        --> ��������
///                 MethodName       --> ������
///                 ExtStr           --> ���ò���(ҽԺ����^ҽ������)
///                 RtnFunction      --> ������ɺ�Ļص���js����
/// �޸����������Ʒ� 2019 05 07 ������
///           ���Ʒ� 2020 03 11 ������ɺ����ӻص�����
function ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam, RtnFunction){
	//�򿪵����Excel����
	try {
		filePath=FileOpenWindow();
	} catch (e) { 
		alert(e.message) ;
		return false;
	}
	if(filePath==""){ return false;}
	
	loadLableInit();                //��ʼ�����ѿ�
	$('#loadLable').show();

	var ErrMsg="";     //����check�Ĵ���
	var errRowNums=0;  //��������
	var sucRowNums=0;  //����ɹ�������
	xlApp = new ActiveXObject("Excel.Application"); 
	xlBook = xlApp.Workbooks.open(filePath); 
	xlBook.worksheets(1).select(); 
	xlsheet = xlBook.ActiveSheet;
	var rows=xlsheet.usedrange.rows.count;
	var columns=xlsheet.usedRange.columns.count;
	try{
		ExcelImportDo(GlobalDataFlg, UserDr, ClassName, MethodName, xlsheet, 2, rows, columns, sucRowNums, errRowNums, ExtStrPam, RtnFunction);
	}
	catch(e){
		alert("����ʱ�����쳣��ErrInfo��"+e.message) ;
		$('#loadLable').hide();
		DestoryExcelObject();
	}
	/*
	finally{
		$('#loadLable').hide();
		xlBook.Close (savechanges=false);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}*/
}

function ExcelImportDo(GlobalDataFlg, UserDr, ClassName, MethodName, xlsheet, rowIndex, allrows, allcols, sucnums, errnums, ExtStrPam, RtnFunction){
	var rtnRowIndex=0;
	var nextRowIndex=0;
	var ImportResultInfo="";
	var InfoRowIndex=rowIndex-1;     ///�����ǵڼ���
	var tmpRows=allrows-1;
	var BaseInfo="���ε�������ݹ���"+tmpRows+"��"+allcols+"�С�";
	var tmpInfo=""
	
	var RowDataStr="";
	var tmpFieldInfo="";
	for(i=1; i<=allcols; i++){
		tmpFieldInfo=SetValue(xlsheet.Cells(rowIndex, i).text);
		if(i==1){
			RowDataStr=tmpFieldInfo;
		}else{
			RowDataStr=RowDataStr+"^"+tmpFieldInfo;
		}
	}
	
	tmpInfo=BaseInfo+"<br/>��ǰ���ڵ����"+InfoRowIndex+"/"+tmpRows+"�����ݡ�";
	$('#loadLable').html(tmpInfo);
	$('#loadLable').show();
	
	//��������
	/*
	var Url=APP_PATH+"/com.ImportOrExportCtl/ExcelImportAjax";
	$.post(
		Url
		,{
			ClassName:ClassName
			,MethodName:MethodName
			,RowIndex:rowIndex
			,RowDataInfo:RowDataStr
			,UserDr:UserDr
			,GlobalDataFlg:GlobalDataFlg
			,ExtStr:ExtStrPam
		}
		,function(data,textStatus){
			$('#loadLable').hide();    //ִ����ɺ�̨����󣬹ر���ʾ��
			if(textStatus=="success"){
				if(data.status>=0){
					if(data.status==0){
						errnums=errnums+1;    //ʧ����Ŀ
					}else{
						sucnums=sucnums+1;    //�ɹ���Ŀ
					}
					//����ɹ���ʱ���ж��Ƿ�����һ����Ҫ���������
					rtnRowIndex=parseInt(data.rowIndex);
					if(rtnRowIndex>=allrows){    //�Ѿ������һ���ĳ���
						DestoryExcelObject();
						ImportResultInfo=BaseInfo+"\n,�ɹ�����"+sucnums+"��,ʧ��"+errnums+"��";
						alert(ImportResultInfo);
					}else{    //�������һ���ĳ���
						nextRowIndex=rtnRowIndex+1;    //��һ������
						ExcelImportDo(GlobalDataFlg, UserDr, ClassName, MethodName, xlsheet, nextRowIndex, allrows, allcols, sucnums, errnums, ExtStrPam);    //������һ������
					}
				}else{
					$.messager.alert('����ʧ��',data.info);
				}
			}else{
				$.messager.alert('ϵͳ����','ϵͳ�쳣�����Ժ�����');
			}
		},
		'json'
	);
	*/
	$cm({
		ClassName:"web.InsuImpOrExpCtl"
		,MethodName:"ExcelImportAjax"
		,ImportClass:ClassName
		,ImportMethod:MethodName
		,RowIndex:rowIndex
		,RowDataInfo:RowDataStr
		,UserDr:UserDr
		,GlobalDataFlg:GlobalDataFlg
		,ExtStr:ExtStrPam
	},function(data){
		$('#loadLable').hide();    //ִ����ɺ�̨����󣬹ر���ʾ��
		if(data.status>=0){
			if(data.status==0){
				errnums=errnums+1;    //ʧ����Ŀ
			}else{
				sucnums=sucnums+1;    //�ɹ���Ŀ
			}
			//����ɹ���ʱ���ж��Ƿ�����һ����Ҫ���������
			rtnRowIndex=parseInt(data.rowIndex);
			if(rtnRowIndex>=allrows){    //�Ѿ������һ���ĳ���
				DestoryExcelObject();
				ImportResultInfo=BaseInfo+"\n,�ɹ�����"+sucnums+"��,ʧ��"+errnums+"��";
				alert(ImportResultInfo);
				//+dongkf 2020 03 11 start
				if(typeof(RtnFunction)=="function"){
					RtnFunction();   //�ص�����
				}
				//+dongkf 2020 03 11 end
			}else{    //�������һ���ĳ���
				nextRowIndex=rtnRowIndex+1;    //��һ������
				ExcelImportDo(GlobalDataFlg, UserDr, ClassName, MethodName, xlsheet, nextRowIndex, allrows, allcols, sucnums, errnums, ExtStrPam, RtnFunction);    //������һ������
			}
		}else{
			$.messager.alert('����ʧ��',data.info);
		}
	});
	
}

/// ����˵��������������ѿ򴴽�
function loadLableInit(){
	//����������ѿ򴴽�
	if($('#loadLable').length==0){
		$loadLable=$("<div id='loadLable' style='display:none;position:absolute;border-style: solid;border-width:1px;border-color:#46A3FF;background-color:#FFFFDF;width:400px;height:60px;z-index:20;left:350px;top:200px;text-align:center;padding:20px;'>���ڵ���</div>");
		$("body").append($loadLable);
	};
}

function SetValue(value)
{
	if(value == undefined)
	{
		value="" ;
	}
	
	value=value.toString().replace(/\"/g, "");
	value=value.toString().replace(/\?/g,"");
	return value;
}

//���ļ��У�ѡ���ļ��Ĺ�ͨ����
function FileOpenWindow(){
	if($('#FileWindowDiv').length==0){
		$('#FileWindowDiv').empty();
		
		$FileWindowDiv=$("<a id='FileWindowDiv' class='FileWindow' style='display:none'>&nbsp;</a>");
		$("body").append($FileWindowDiv);
		$FileWindow=$("<input id='FileWindow' type='file' name='upload'/>");
		$("#FileWindowDiv").append($FileWindow);
	}
	$('#FileWindow').val("");
	$('#FileWindow').select();
	$(".FileWindow input").click();
	var FilePath=$('#FileWindow').val();
	//alert(FilePath);
	return FilePath;
}

$(".FileWindow").on("change","input[type='file']",function(){
	//alert(3233);
	var filePath=$(this).val();
	alert("filePath="+filePath);
});