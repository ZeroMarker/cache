
/*
*
*�ļ����ƣ�insu/com/uploadfile.js
*����˵����ͨ���ϴ�����
*�޸�����������  2023-01-03
*/


var GV = {
	file: [], //ͼƬ����
	files: [], //ͼƬbase������
	ProofType: "", 		//�ϴ��ļ�����
	TargetRecDr: "",  	//��������Dr
	fileMaxSize: "",		//�ļ�����С	
	FileExtStrs: "",		//�ļ���׺����Ϣ	
	ProoFileMaxNum: "",  //����ϴ��ļ���
	tmpPro: 0,      		//�ļ��ϴ�����
};

$(document).ready(function () {

	setLayout();
});
function setLayout() {
	InitParam(); 	//��ʼ���ϴ�ҳ��

	setDataView();  //��ʼ���������
	init_Upload();  //��ʼ���ϴ����
	setElementEvent(); //����ҳ�����¼�

}
//����˵������ʼ���ϴ�ҳ�� 
function InitParam() {
	var OpenMode = $("#OpenMode").val();    //��ģʽ 0-->�ϴ�ģʽ 1-->�����鿴�Ѿ��ϴ��ļ�ģʽ
	var html = '';
	html += '<div  class="hisui-layout" data-options="fit:true,border:false" >';
	html += '<div data-options="region:\'center\',title:\'\',border:false" style="padding:10px;">';

	//���ô�ģʽ
	if (OpenMode == "0") {
		$('#uploadFileArea').show();    //�����ϴ�ģʽ �ſ����ϴ��ļ�
		html += '<table  id="FileList"  style="height:400px;"></table>';

	} else {
		$('#uploadFileArea').hide();     //�����ϴ����

		var tab = $('#FileTabs').tabs('getTab', 0); // ȡ�õ�һ��tab
		$('#FileTabs').tabs('update', {  //�޸�ҳǩ����
			tab: tab,
			options: {
				title: '�����б�'
			}
		});

		html += '<table id="FileList" style="height:440px;"></table>';
		$('#FileTabs').tabs('select', '����');
	}
	html += '</div></div>';

	$('#uploadFile').append(html);

	//��ȡ�ļ��ϴ���Ϣֵ
	GV.ProofType = $("#ProofType").val();
	GV.TargetRecDr = $("#TargetRecDr").val();
	GV.fileMaxSize = $("#fileMaxSize").val();
	GV.FileExtStrs = $("#FileExtStrs").val();
	GV.ProoFileMaxNum = $("#ProoFileMaxNum").val();

	QueryFileList();
}

// ����˵�������ø���չʾ�����Ϣ
function setDataView() {
	$("#FileList").datagrid({
		bodyCls: 'panel-body-gray',

		pagination: 'true',
		pageSize: '20',
		pageList: [20, 30, 50],
		singleSelect: 'true',
		//fit:'true',
		sortName: 'FileName',
		order: 'asc',
		columns: [[
			{
				field: 'FileSaveName', title: '�ļ�����', width: 150
				, formatter: function (value, row) {
					var htmlStr = "<a class='preverpng' title='����鿴' style='text-decoration: underline;color:#0000CC'>" + value + "&nbsp;&gt;&gt;" + "</a>";

					return htmlStr;
				}
			},
			{ field: 'FileSize', title: '�ļ���С', width: 100 },
			{ field: 'FileExtType', title: '���ݸ�ʽ', width: 100 },
			{ field: 'UpdateUser', title: '�ϴ���', width: 100 },
			{ field: 'UpdateDate', title: '�ϴ�����', width: 135 },
			{ field: 'FileWebPath', title: '�ļ�·��', width: 400, hidden: true },
			{ field: 'ID', title: 'ID', width: 80, hidden: true },
		]]
		, onClickCell: function (rowIndex, field, value) {  //������������  �򿪶�Ӧ�������в鿴
			if (field == "FileSaveName") {
				$('#FileTabs').tabs('select', '����');
				$("#attachType").keywords("select", "x" + rowIndex);
			}
		}
		, onDblClickRow: function (rowIndex, rowData) {    //˫���� ɾ��������
			var OpenMode = $('#OpenMode').val();   //��ģʽ
			if (OpenMode == "1") {
				return 0;
			}

			var FileSaveName = rowData.FileSaveName;    //�ļ�����
			var confirmMsg = '��ȷ����Ҫɾ�����ϴ����ļ�[' + FileSaveName + ']��'
			$.messager.confirm('ȷ��', confirmMsg, function (r) {
				if (r) {
					var rowid = rowData.ID;    //�ļ���ϢID
					DeleteUploadFile(rowid);
				}
			});
		},
		onLoadSuccess: function () {//����ƶ��������У�������ʾ��������  +gongxin 20230215
			var OpenMode = $('#OpenMode').val();   //��ģʽ
			if (OpenMode == "1") {
				return 0;
			}
			mytitle();      //����ƶ��������У�������ʾ��������  +gongxin 20230215
		},
	})
}


// ����˵������˳�򱣴�ȫ���ļ������ݿ�
function SaveAllData(index) {
	return new Promise(function (resolve, reject) {

		$.m({
			ClassName: "INSU.COM.BL.UploadFileInfoCtl",
			MethodName: "UpdDocCommonInfo",
			type: GV.ProofType,
			DataId: GV.TargetRecDr,
			FileSaveName: GV.file[i].name.split('.')[0],
			userId: session['LOGON.USERID'],
			uploadFile: GV.files[i],
			ExtStr: GV.file[i].size + "^" + GV.file[i].name.split('.')[1],
			fileMaxSize: GV.fileMaxSize,   //�ļ�����С
			FileExtStrs: GV.FileExtStrs,   //�ļ���ʽ
			ProoFileMaxNum: GV.ProoFileMaxNum //�ļ�������
		}, function (rtnData) {
			GV.tmpPro += 1;
			if (rtnData != "") {
				$.messager.alert('��ʾ', '�ļ�[' + (GV.file[GV.tmpPro - 1].name) + ']�������' + rtnData, 'error');
			}
			if (GV.tmpPro == GV.files.length) {
				setTimeout('QueryFileList()', 100);
				GV.files = [];
				GV.file = [];
			}
			resolve();
		});

	})
}

//����ҳ�����¼�
function setElementEvent() {
	$("#btnSave").on("click", function () {
		GV.tmpPro = 0;
		if (GV.files.length > 0) {
			for (i = 0; i < GV.file.length; i++) {

				SaveAllData(i);
			}
		}
		$('#Picture').filebox('clear');

	});


	// ���  upt 2023/2/20 JinS1010
	$("#btnClean").on("click", function () {
		$('#Picture').filebox('clear');
		GV.files = [];
		GV.file = [];

	});
}

///����˵����ɾ���ϴ����ļ�
function DeleteUploadFile(FileRecDr) {
	if (FileRecDr == "") {
		return 0;
	}
	$m({
		ClassName: "INSU.COM.BL.UploadFileInfoCtl",
		MethodName: "DeleUploadFile",
		ID: FileRecDr
	}, function (jsonData) {
		QueryFileList();
	});
}

//����˵������ʼ���ϴ����
function init_Upload() {
	$("#Picture").filebox({
		prompt: 'ͼƬ���֧��2M��֧�ָ�ʽΪjpg��jpeg��png��bmp��gif',
		plain: true,
		multiple: true,
		onChange: function (newVal, oldVal) {
			GV.file = [];
			GV.files = [];
			newVal = newVal.split(',');
			if (newVal.length > 0) {
				for (var i = 0; i < newVal.length; i++) {
					GV.file[i] = $("#Picture").filebox("files")[i];
					var reader = new FileReader();
					reader.readAsDataURL(GV.file[i]); //���ļ���Data URL��ʽ����ҳ��
					reader.onload = (function (i, event) {
						GV.files[i] = event.target.result;
					}).bind(reader, i);
				}
			}
		}
	});
}



//����˵������ѯ��������
function QueryFileList() {
	var queryParams = {
		ClassName: "INSU.COM.BL.UploadFileInfoCtl",
		QueryName: "QueryUploadFileInfo",
		TargetRecDr: GV.TargetRecDr,
		ProofType: GV.ProofType,
	}
	//��ʼ�������б�
	$cm({
		ClassName: "INSU.COM.BL.UploadFileInfoCtl",
		QueryName: "QueryUploadFileInfo",
		TargetRecDr: GV.TargetRecDr,
		ProofType: GV.ProofType,
	}, function (Data) {
		var rows = Data.rows;
		var length = rows.length;
		var Items = [];
		var Item = {};

		var rtnItems = [];   //����ֵ���鱣�� //+���� 20230110 ���ӷ��غ��������ӷ���ֵ
		var rtnItem = {};  //+���� 20230110 ���ӷ��غ��������ӷ���ֵ

		for (var i = 0; i < length; i++) {
			Item = {};
			rtnItem = {};  //+���� 20230110 ���ӷ��غ��������ӷ���ֵ

			Item['text'] = rows[i].FileName;
			Item['text'] = rows[i].FileSaveName;
			Item['id'] = "x" + i;
			Item['value'] = rows[i].ID;

			rtnItem['name'] = rows[i].FileSaveName;
			rtnItem['id'] = rows[i].ID;


			Item['FileStream'] = $m({
				ClassName: "INSU.COM.BL.UploadFileInfoCtl",
				MethodName: "ReadStreamDemo",
				id: rows[i].ID,
			}, false);

			//rtnItem['imgdata']=Item['FileStream'];  ����ǰֱ̨�Ӵ�ͼƬbase64����

			if (i == 0) {
				Item['selected'] = true;
			}

			Items[i] = Item;
			rtnItems[i] = rtnItem;  //+���� 20230110 ���ӷ��غ��������ӷ���ֵ
		}

		parent.window.$("#WinRtnData").text(JSON.stringify(rtnItems));    //��ͼƬ������id�浽ǰ̨

		if (length > 0) {

			init_attachType(Items);
			init_attachDetail(Items[0].FileStream, Items[0].text);
		} else {
			$("#attachType").keywords({
				items: [],
			});
			document.getElementById("attach").innerHTML = "";
		}
	});
	loadDataGridStore('FileList', queryParams);

}

//��ʼ�������ؼ���
function init_attachType(Items) {

	$("#attachType").keywords({

		singleSelect: true,
		items: Items,

		onClick: function (v) {
			init_attachDetail(v.FileStream, v.text);
		},
	});
	$(".kw-section-list").find("li").css("margin-left", "5px");

}

//����˵������������չʾ
function init_attachDetailOld(Data, Name) {
	var strhtml = '';
	strhtml += '<img id="img-attach" style="max-width: 760px; height: auto;display: block;-webkit-user-select: none;margin: auto;position:absolute;left:0;right:0;bottom:0;top:0" src="' + Data + '" name="' + Name + '">';
	document.getElementById("attach").innerHTML = strhtml;
	$("#img-attach").tooltip({
		position: 'top',
		content: '˫����ͼ��ʾ'

	});
	$("#img-attach").dblclick(function () {
		var img = new Image();
		img.src = $("#img-attach").attr("src");

		img.style = "display: block;-webkit-user-select: none;margin: auto;position:absolute;left:0;right:0;bottom:0;top:0";
		img.style.cssText = "display: block;-webkit-user-select: none;margin: auto;position:absolute;left:0;right:0;bottom:0;top:0";
		var newWin = window.open('', '_blank');
		newWin.document.write(img.outerHTML);
		newWin.document.title = "����" + $("#img-attach").attr("name");;
		newWin.document.close();

	});

}

//����˵������������չʾ
function init_attachDetail(Data, Name) {
	var img = new Image();
	img.src = Data;
	var originalWidth = img.width; //ͼƬ���
	var originalHeight = img.height; //ͼƬ�߶�
	var strhtml = '';
	if (originalHeight > originalWidth) {
		strhtml += '<img id="img-attach" style="width: auto; max-height: 420px;display: block;-webkit-user-select: none;margin: auto;position:absolute;left:0;right:0;bottom:0;top:0" src="' + Data + '" name="' + Name + '">';
	} else {
		strhtml += '<img id="img-attach" style="max-width: 760px; height: auto ;display: block;-webkit-user-select: none;margin: auto;position:absolute;left:0;right:0;bottom:0;top:0" src="' + Data + '" name="' + Name + '">';
	}
	document.getElementById("attach").innerHTML = strhtml;
	/*$("#img-attach").tooltip({
		position: 'top',    
		content: '˫����ͼ��ʾ'
		
	});*/
	detail_title();


	$("#img-attach").dblclick(function () {
		if (originalHeight > originalWidth) {
			img.style.cssText = "width: auto; height: 100%;display: block;-webkit-user-select: none;margin: auto;position:absolute;left:0;right:0;bottom:0;top:0";
		} else {
			img.style.cssText = "width: auto; height: auto;display: block;-webkit-user-select: none;margin: auto;position:absolute;left:0;right:0;bottom:0;top:0";
		}

		var newWin = window.open('', '_blank');
		newWin.document.write(img.outerHTML);
		newWin.document.title = "����" + $("#img-attach").attr("name");;
		newWin.document.close();

	});

}




//------------------------------------------------------------------------------------//
// title��ʽ   //+gongxin 20230215 ��ʾɾ�����ݷ���
function mytitle() {

	var x = 15;
	var y = 30;
	var newtitle = '';
	$('.datagrid-row').mouseover(function (e) {
		var temp0 = this.cells[6];
		var temp1 = this.cells[7];
		if ("undefined" == typeof temp0) {
			return;
		}
		if ("undefined" != typeof temp1) {
			return;
		}

		var temp = this.cells[6].children[0].className;
		if ("undefined" == typeof temp) {
			return;
		}
		if ("datagrid-cell datagrid-cell-c1-ID" == temp) {
			newtitle = "˫��ɾ���ļ�";
		}

		if ("" == newtitle) {
			return;
		}
		if (e.target.className != "datagrid-cell datagrid-cell-c1-FileSaveName" && e.target.className != "preverpng") {
			this.title = '';
			$('body').append('<div id="mytitle" >' + newtitle + '</div>');
			$('#mytitle').css({
				'left': (e.pageX + x + 'px'),
				'top': (e.pageY + y - 80 + 'px'),
				'position': 'absolute'
			}).show();
		}
	}).mouseout(function () {
		this.title = "";

		$('#mytitle').remove();
	}).mousemove(function (e) {
		if (e.target.className != "datagrid-cell datagrid-cell-c1-FileSaveName" && e.target.className != "preverpng") {
			$('#mytitle').css({
				'left': (e.pageX + x + 10 + 'px'),
				'top': (e.pageY + y - 60 + 'px'),
				'position': 'absolute'
			}).show();
		}
	});
}

// title��ʽ   //+gongxin 20230220 ��ʾͼƬ��������
function detail_title() {
	var x = 15;
	var y = 30;
	var newtitle = '';
	$('#img-attach').mouseover(function (e) {
		newtitle = this.title;
		newtitle = "˫����ͼ��ʾ";
		this.title = '';
		$('body').append('<div id="mytitleimg" >' + newtitle + '</div>');
		$('#mytitleimg').css({
			'left': (e.pageX + x + 'px'),
			'top': (e.pageY + y - 80 + 'px'),
			'position': 'absolute'
		}).show();
	}).mouseout(function () {
		this.title = newtitle;
		$('#mytitleimg').remove();
	}).mousemove(function (e) {
		$('#mytitleimg').css({
			'left': (e.pageX + x + 10 + 'px'),
			'top': (e.pageY + y - 60 + 'px'),
			'position': 'absolute'
		}).show();
	});
}
