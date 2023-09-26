
//确定
function confirm()
{
	if(selectNode == null)
	{
		return;	
	}
	if(selectNode.id == "RT0")
	{
		return;
	}	
	if(!selectNode.isLeaf())
	{
		parentId = selectNode.id;
		categoryChapterId = ""
	}
	else
	{
		parentId = selectNode.parentNode.id;
		categoryChapterId = selectNode.id;
	}
	Ext.getCmp('cboEprRecord').setValue(selectNode.text);	
}

//浏览
function browser()
{
	//document.getElementById('divDateTimeSelect').style.top = 0;
	//return;
	if(parentId == "")
	{
		alert('请先选择要浏览的病历!');	
		return;	
	}
	/*
	if (!parent.frames['centerTab'].frames['centerTabDetial'] && !parent.frames['centerTab'].frames['centerTabListDetial'])
	{
		alert('请先打开一个病历书写界面,然后再进行浏览操作!');
		return;
	}
	*/
	document.getElementById('divDateTimeSelect').style.top = 0;
	
	frames['frameBrowserPhotoNew'].document.getElementById('browserPhoto').innerHTML = "请稍候...";
	//初始化起始页和终止页
	var count = parseInt(Ext.getCmp("cboBrowerCount").value, 10);
	startIndex = 1;
	endIndex = count;
	
	var startDate = Ext.getCmp('startDate').value;
	var endDate = Ext.getCmp('endDate').value;	
	
	var startTime = Ext.getCmp('startTime').value;
	var endTime = Ext.getCmp('endTime').value;
	
	imageList = "";
	
	arrTmp = null;
	arrTmp = new Array();
	
	total = 0;
	
	if (parentId == '')
	{
		frames['frameBrowserPhotoNew'].document.getElementById('browserPhoto').innerHTML = "";
		return;
	}	
	
	//异步获得打印模板id集合
	Ext.Ajax.request({			
		url: '../web.eprajax.eprBorwser.printTemplateId.cls',
		timeout : parent.parent.timedOut,
		params: { parentId: parentId.substring(2, parentId.length), categoryChapterId: categoryChapterId, startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, episodeID: episodeID, patientID: patientID},
		success: function(response, opts) {
			imageList = response.responseText;
			if( imageList == 'NoPower')
			{
				frames['frameBrowserPhotoNew'].document.getElementById('browserPhoto').innerHTML = "对不起,您没有浏览权限!";
				return;
			}
			if( imageList == 'docIdListnull')
			{
				//alert('没有找到相关图片!错误代码:docIdList null');
				frames['frameBrowserPhotoNew'].document.getElementById('browserPhoto').innerHTML = "没有找到相关病历!";
				return;
			}
			if( imageList == 'logIdListnull')
			{
				//alert('没有找到相关图片!错误代码:logIdList null');
				frames['frameBrowserPhotoNew'].document.getElementById('browserPhoto').innerHTML = "没有找到相关病历!";
				return;
			}
			
			if (imageList == "")
			{
				//alert("获取图片集合失败!错误代码:imageList null");
				frames['frameBrowserPhotoNew'].document.getElementById('browserPhoto').innerHTML = "没有找到相关病历!";
			}
			else
			{
				total = parseInt(imageList.split('$')[0], 10);
				queryPhoto(imageList);
			}
		},
		failure: function(response, opts) {
			alert(response.responseText);
		}
	});
}

//调用dll下载图片
function queryPhoto(imageList)
{
    //FTP^10.10.141.116^21^anonymous^1^1000
    var arrSavePrintImage = SavePrintImage.split('^');
    var ftpAddress = arrSavePrintImage[1];
    var user = arrSavePrintImage[3];
    var pwd = arrSavePrintImage[4];
    
    var arrImgFtp = new Array();
    //串的结构为4$98^1#101^1#99^0#102^1#110^0#100^1#129^0#128^0
    var loglist = imageList.split('$')[1];
    var arrLog = loglist.split('#');
    for (var i = 0; i < arrLog.length; i++)
    {
		var logID = arrLog[i].split('^')[0];
		var imageCount = arrLog[i].split('^')[1];
		for (var j = 1; j <= imageCount; j++)
		{
			arrImgFtp = arrImgFtp.concat('ftp://' + user + ':' + pwd + '@' + ftpAddress + '/' + patientID + "/" + episodeID + '/' + logID + '/' + j + '.gif');
		}
    }
    
	frames['frameBrowserPhotoNew'].document.getElementById('browserPhoto').innerHTML = "";
	
	
	
	var table = '<table cellpadding="0" cellspacing="0">'
	for(var i = startIndex - 1; i < (arrImgFtp.length < endIndex ? arrImgFtp.length : endIndex); i++)				
	{
		table +='<tr><td><img src="' + arrImgFtp[i] + '"/></td></tr>'
		//将arrTmp[i + arrTmp.length] = arr[i] 该为arrTmp = arrTmp.concat(arr[i]), 2009-9-7
		//arrTmp[i + arrTmp.length] = arr[i];
		arrTmp = arrTmp.concat(arrImgFtp[i]);
	}
	table += '</table>'
	frames['frameBrowserPhotoNew'].document.getElementById('browserPhoto').innerHTML = table;
	
	//点击浏览后将按钮下一页Enable设置为True
	Ext.getCmp('btnNext').enable();
	if(endIndex >= total)
	{
		Ext.getCmp('btnNext').disable();				
	}
}

//上一页
function prev()
{
	//开始页小于1,直接返回
	if (startIndex <= 1)
	{
		Ext.getCmp('btnPreview').disable();
		return;
	}
	
	//点击时将按钮下一页Enable设置为True
	Ext.getCmp('btnNext').enable();
	
	var count = parseInt(Ext.getCmp("cboBrowerCount").value, 10);
	startIndex = startIndex - count;
	endIndex = endIndex - count;
	
	//读取缓存中的数据
	var table = '<table cellpadding="0" cellspacing="0">'
	for(var i = startIndex - 1; i <= endIndex - 1; i++)	{
		table +='<tr><td><img src="' + arrTmp[i] + '"/></td></tr>';
	}
	table += '</table>';
	frames['frameBrowserPhotoNew'].document.getElementById('browserPhoto').innerHTML = table;
	
	
		
	//开始页小于1,将其禁用掉
	if (startIndex <= 1)
	{
		Ext.getCmp('btnPreview').disable();
	}
	
}

//下一页
function next()
{
	if(endIndex >= total)
	{
		Ext.getCmp('btnNext').disable();
		return;
	}
	Ext.getCmp('btnPreview').enable();
	
	var count = parseInt(Ext.getCmp("cboBrowerCount").value, 10);
	startIndex = startIndex + count;
	endIndex = endIndex + count;
	
	//读取缓存中的数据
	if (startIndex <= arrTmp.length)
	{
		var table = '<table cellpadding="0" cellspacing="0">'
		//将endIndex-1 替换为 arrTmp.length - 1?2009-9-7
		for(var i = startIndex - 1; i <= endIndex - 1; i++)	{
			table +='<tr><td><img src="' + arrTmp[i] + '"/></td></tr>';
		}
		table += '</table>';
		frames['frameBrowserPhotoNew'].document.getElementById('browserPhoto').innerHTML = table;
	}
	else
	{
		queryPhoto(imageList);
	}
	
	if(endIndex >= total)
	{
		Ext.getCmp('btnNext').disable();
	}
}

//鼠标点击到'日期选择'上的方法
function sltDT()
{
	var top = document.getElementById('divDateTimeSelect').style.top;
	
	if (top == '0px')
	{
		Ext.get('divDateTimeSelect').shift({			
			y: 28
 		});
	}
	else if (top == '28px')
	{
		Ext.get('divDateTimeSelect').shift({			
			y: 0
 		});	
	}
 	
}
