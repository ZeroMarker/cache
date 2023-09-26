// Custom example logic

var uploader = new plupload.Uploader({
	runtimes : 'html5,flash,silverlight,html4',
	url : '../EMRservice.Ajax.iBook.cls',
	browse_button : 'pickfiles',
	multi_selection : false,
	//url : 'emr.medical.repository.ibook.csp',
	filters : {
		max_file_size : '10mb',
		mime_types: [
			{title : "HTML files", extensions : "html"}
		]
	},

	init: {
		PostInit: function() {
			document.getElementById('submit').onclick = function() {
				uploader.setOption(
					'multipart_params',
					{
						Author: $('#Author').val(),
						Category: parentid,
						Summary: $('#Summary').val(),
						Title: $('#Title').text(),
						UserInfo: userID+'^'+userLocID+'^'+ssgroupID+'^'
					}
				);
				uploader.start();
				return false;
			};
		},
		
		FileFiltered: function(up, files) {
			plupload.each(this.files, function(file){
				up.removeFile(file);
			});
		},
		
		//自动获取文件名，文件名可更改
		FilesAdded: function(up, files) {
			plupload.each(files, function(file) {
				var name = file.name;
				$('#File').text(name);
				$('#Title').text(name.substr(0,name.lastIndexOf('.')));
			});
		},
		
		FileUploaded:function(up,file,result){
			var d = result.response;
			if(d.substr(0,3)=="100"){
				alert('新增成功');
				//在父页面的对应位置加入新文献，如果parentid>=7则加在对应目录，否则加在‘其他’中，没有其他时连其他一同创建
				d = d.substr(4);
				var link = makeibook(d);
				var Category = $('#CG0'+parentid, window.parent.document);
				if((parentid <7)&&(Category.length==0)){
					var subitem = makesubitem('CG0'+parentid);
					$(subitem).find('dd').append(link);
					$('#CG'+parentid, window.parent.document).append(subitem);
					return;
				}else if((parentid <7)){
					$(Category).find('dd').append(link);
					return;
				}
				Category = $('#CG'+parentid, window.parent.document);
				$(Category).find('dd').append(link);
			}else{
				alert('操作失败');
			}
		},
		
		Error: function(up, err) {
			alert("\nError #" + err.code + ": " + err.message);
		}
	}
});

uploader.init();

$(function(){
	$('#File').attr('readonly','readonly');
	$('#File').attr('disabled','disabled');
	$('#Parent').text(parentname);
	$('#Parent').attr('readonly','readonly');
	$('#Parent').attr('disabled','disabled');
	/*$('#submit').bind('click',function(){
		if($('#Title').val()=="") return;
		if($('#FilePath').val()=="") return;
		//为了Cache中的运行，将"替换为""
		var filehtml_replace = filehtml.replace(/"/g,'""');
		$.ajax({
			type: "POST",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			data: {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLiBook",
				"Method":"AddiBook",
				"p1":$('#Title').val(),
				"p2":$('#Author').val(),
				"p3":parentid,
				"p4":$('#Summary').val(),
				"p5":filehtml_replace,
				"p6":userID+'^'+userLocID+'^'+ssgroupID+'^'
			},
			success: function(d){
				if(d.substr(0,3)=="100"){
					alert('新增成功');
					//在父页面的对应位置加入新文献，如果parentid>=7则加在对应目录，否则加在‘其他’中，没有其他时连其他一同创建
					d = d.substr(4);
					var link = makeibook(d);
					var Category = $('#CG0'+parentid, window.parent.document);
					if((parentid <7)&&(Category.length==0)){
						var subitem = makesubitem('CG0'+parentid);
						$(subitem).find('dd').append(link);
						$('#CG'+parentid, window.parent.document).append(subitem);
						return;
					}else if((parentid <7)){
						$(Category).find('dd').append(link);
						return;
					}
					Category = $('#CG'+parentid, window.parent.document);
					$(Category).find('dd').append(link);
				}else{
					alert('操作失败');
				}
			},
			error: function(d){
				alert(d);
			}
		});
	});*/
});

function  handleFiles(FilePath){
	//获取文件流字符串
	//filehtml = "";
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var f1 = fso.OpenTextFile(FilePath.value,1);
	//while (!f1.AtEndOfStream) filehtml += f1.ReadLine(); 
	uploader.addFile(uploader.getFile(FilePath.value));    
	f1.Close();
	//如果此时题目项为空，则自动获取标题
	if($('#Title').val()==''){
		var indexstart = FilePath.value.lastIndexOf('\\');
		var indexend = FilePath.value.lastIndexOf('.');
		$('#Title').text(FilePath.value.substr(indexstart+1,indexend-indexstart-1));
	}
}

function makesubitem(CategoryID){
	var subitem = $('<div class="subitem" style="width:auto"></div>');
	var content = $('<dl></dl>');
	$(content).append('<dt><a href="#">其他</a></dt>');
	$(content).attr('id',CategoryID);
	$(content).append($('<dd></dd>'));
	$(subitem).append(content);
	return subitem;
}

function makeibook(iBookID){
	if ($.browser.msie && $.browser.version == '6.0')
	{
		var link = $('<a href="#" class="list"></a>');
	}else
	{
		var link = $('<p class="list"></p>');
	}
	$(link).attr({"id":iBookID,"text":$('#Title').val()});
	$(link).append('<div class="ibook">'+$('#Title').val()+'</div>');
	return link;
}