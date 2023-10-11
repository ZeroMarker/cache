
/*
*
*文件名称：insu/com/uploadfile.js
*功能说明：通用上传测试
*修改履历：巩鑫  2023-01-03
*/


var GV = {
	file: [], //图片数据
	files: [], //图片base流数据
	ProofType: "", 		//上传文件类型
	TargetRecDr: "",  	//所属数据Dr
	fileMaxSize: "",		//文件最大大小	
	FileExtStrs: "",		//文件后缀名信息	
	ProoFileMaxNum: "",  //最大上传文件数
	tmpPro: 0,      		//文件上传进度
};

$(document).ready(function () {

	setLayout();
});
function setLayout() {
	InitParam(); 	//初始化上传页面

	setDataView();  //初始化附件表格
	init_Upload();  //初始化上传组件
	setElementEvent(); //设置页面点击事件

}
//功能说明：初始化上传页面 
function InitParam() {
	var OpenMode = $("#OpenMode").val();    //打开模式 0-->上传模式 1-->仅仅查看已经上传文件模式
	var html = '';
	html += '<div  class="hisui-layout" data-options="fit:true,border:false" >';
	html += '<div data-options="region:\'center\',title:\'\',border:false" style="padding:10px;">';

	//设置打开模式
	if (OpenMode == "0") {
		$('#uploadFileArea').show();    //仅仅上传模式 才可以上传文件
		html += '<table  id="FileList"  style="height:400px;"></table>';

	} else {
		$('#uploadFileArea').hide();     //隐藏上传组件

		var tab = $('#FileTabs').tabs('getTab', 0); // 取得第一个tab
		$('#FileTabs').tabs('update', {  //修改页签标题
			tab: tab,
			options: {
				title: '附件列表'
			}
		});

		html += '<table id="FileList" style="height:440px;"></table>';
		$('#FileTabs').tabs('select', '附件');
	}
	html += '</div></div>';

	$('#uploadFile').append(html);

	//获取文件上传信息值
	GV.ProofType = $("#ProofType").val();
	GV.TargetRecDr = $("#TargetRecDr").val();
	GV.fileMaxSize = $("#fileMaxSize").val();
	GV.FileExtStrs = $("#FileExtStrs").val();
	GV.ProoFileMaxNum = $("#ProoFileMaxNum").val();

	QueryFileList();
}

// 功能说明：设置附件展示表格信息
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
				field: 'FileSaveName', title: '文件名称', width: 150
				, formatter: function (value, row) {
					var htmlStr = "<a class='preverpng' title='点击查看' style='text-decoration: underline;color:#0000CC'>" + value + "&nbsp;&gt;&gt;" + "</a>";

					return htmlStr;
				}
			},
			{ field: 'FileSize', title: '文件大小', width: 100 },
			{ field: 'FileExtType', title: '数据格式', width: 100 },
			{ field: 'UpdateUser', title: '上传人', width: 100 },
			{ field: 'UpdateDate', title: '上传日期', width: 135 },
			{ field: 'FileWebPath', title: '文件路径', width: 400, hidden: true },
			{ field: 'ID', title: 'ID', width: 80, hidden: true },
		]]
		, onClickCell: function (rowIndex, field, value) {  //单击附件名称  打开对应附件进行查看
			if (field == "FileSaveName") {
				$('#FileTabs').tabs('select', '附件');
				$("#attachType").keywords("select", "x" + rowIndex);
			}
		}
		, onDblClickRow: function (rowIndex, rowData) {    //双击后 删除改数据
			var OpenMode = $('#OpenMode').val();   //打开模式
			if (OpenMode == "1") {
				return 0;
			}

			var FileSaveName = rowData.FileSaveName;    //文件名称
			var confirmMsg = '您确认想要删除已上传的文件[' + FileSaveName + ']吗？'
			$.messager.confirm('确认', confirmMsg, function (r) {
				if (r) {
					var rowid = rowData.ID;    //文件信息ID
					DeleteUploadFile(rowid);
				}
			});
		},
		onLoadSuccess: function () {//鼠标移动到数据行，悬浮提示操作方法  +gongxin 20230215
			var OpenMode = $('#OpenMode').val();   //打开模式
			if (OpenMode == "1") {
				return 0;
			}
			mytitle();      //鼠标移动到数据行，悬浮提示操作方法  +gongxin 20230215
		},
	})
}


// 功能说明：按顺序保存全部文件到数据库
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
			fileMaxSize: GV.fileMaxSize,   //文件最大大小
			FileExtStrs: GV.FileExtStrs,   //文件格式
			ProoFileMaxNum: GV.ProoFileMaxNum //文件最大个数
		}, function (rtnData) {
			GV.tmpPro += 1;
			if (rtnData != "") {
				$.messager.alert('提示', '文件[' + (GV.file[GV.tmpPro - 1].name) + ']保存出错：' + rtnData, 'error');
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

//设置页面点击事件
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


	// 清空  upt 2023/2/20 JinS1010
	$("#btnClean").on("click", function () {
		$('#Picture').filebox('clear');
		GV.files = [];
		GV.file = [];

	});
}

///功能说明：删除上传的文件
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

//功能说明：初始化上传组件
function init_Upload() {
	$("#Picture").filebox({
		prompt: '图片最大支持2M，支持格式为jpg、jpeg、png、bmp、gif',
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
					reader.readAsDataURL(GV.file[i]); //将文件以Data URL形式读入页面
					reader.onload = (function (i, event) {
						GV.files[i] = event.target.result;
					}).bind(reader, i);
				}
			}
		}
	});
}



//功能说明：查询附件数据
function QueryFileList() {
	var queryParams = {
		ClassName: "INSU.COM.BL.UploadFileInfoCtl",
		QueryName: "QueryUploadFileInfo",
		TargetRecDr: GV.TargetRecDr,
		ProofType: GV.ProofType,
	}
	//初始化附件列表
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

		var rtnItems = [];   //返回值数组保存 //+巩鑫 20230110 增加返回函数，增加返回值
		var rtnItem = {};  //+巩鑫 20230110 增加返回函数，增加返回值

		for (var i = 0; i < length; i++) {
			Item = {};
			rtnItem = {};  //+巩鑫 20230110 增加返回函数，增加返回值

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

			//rtnItem['imgdata']=Item['FileStream'];  不在前台直接存图片base64编码

			if (i == 0) {
				Item['selected'] = true;
			}

			Items[i] = Item;
			rtnItems[i] = rtnItem;  //+巩鑫 20230110 增加返回函数，增加返回值
		}

		parent.window.$("#WinRtnData").text(JSON.stringify(rtnItems));    //将图片姓名和id存到前台

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

//初始化附件关键字
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

//功能说明：附件内容展示
function init_attachDetailOld(Data, Name) {
	var strhtml = '';
	strhtml += '<img id="img-attach" style="max-width: 760px; height: auto;display: block;-webkit-user-select: none;margin: auto;position:absolute;left:0;right:0;bottom:0;top:0" src="' + Data + '" name="' + Name + '">';
	document.getElementById("attach").innerHTML = strhtml;
	$("#img-attach").tooltip({
		position: 'top',
		content: '双击大图显示'

	});
	$("#img-attach").dblclick(function () {
		var img = new Image();
		img.src = $("#img-attach").attr("src");

		img.style = "display: block;-webkit-user-select: none;margin: auto;position:absolute;left:0;right:0;bottom:0;top:0";
		img.style.cssText = "display: block;-webkit-user-select: none;margin: auto;position:absolute;left:0;right:0;bottom:0;top:0";
		var newWin = window.open('', '_blank');
		newWin.document.write(img.outerHTML);
		newWin.document.title = "附件" + $("#img-attach").attr("name");;
		newWin.document.close();

	});

}

//功能说明：附件内容展示
function init_attachDetail(Data, Name) {
	var img = new Image();
	img.src = Data;
	var originalWidth = img.width; //图片宽度
	var originalHeight = img.height; //图片高度
	var strhtml = '';
	if (originalHeight > originalWidth) {
		strhtml += '<img id="img-attach" style="width: auto; max-height: 420px;display: block;-webkit-user-select: none;margin: auto;position:absolute;left:0;right:0;bottom:0;top:0" src="' + Data + '" name="' + Name + '">';
	} else {
		strhtml += '<img id="img-attach" style="max-width: 760px; height: auto ;display: block;-webkit-user-select: none;margin: auto;position:absolute;left:0;right:0;bottom:0;top:0" src="' + Data + '" name="' + Name + '">';
	}
	document.getElementById("attach").innerHTML = strhtml;
	/*$("#img-attach").tooltip({
		position: 'top',    
		content: '双击大图显示'
		
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
		newWin.document.title = "附件" + $("#img-attach").attr("name");;
		newWin.document.close();

	});

}




//------------------------------------------------------------------------------------//
// title样式   //+gongxin 20230215 提示删除数据方法
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
			newtitle = "双击删除文件";
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

// title样式   //+gongxin 20230220 提示图片操作方法
function detail_title() {
	var x = 15;
	var y = 30;
	var newtitle = '';
	$('#img-attach').mouseover(function (e) {
		newtitle = this.title;
		newtitle = "双击大图显示";
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
