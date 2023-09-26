
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

function browser()
{
	//document.getElementById('divDateTimeSelect').style.top = 0;
	//return;
	if(parentId == "")
	{
		alert('请先选择要浏览的病历!');	
		return;	
	}
	
	
	
	document.getElementById('divDateTimeSelect').style.top = 0;
	
	frames['frameBrowserPhotoNew'].document.getElementById('browserPhoto').innerHTML = "请稍候...";
	//初始化起始页和终止页
	var count = parseInt(Ext.getCmp("cboBrowerCount").value, 10);
	startIndex = 1;
	endIndex = count;
	
	//初始化开始日期和结束日期
	var startDate = Ext.getCmp('startDate').value;
	var endDate = Ext.getCmp('endDate').value;	
	
	var startTime = Ext.getCmp('startTime').value;
	var endTime = Ext.getCmp('endTime').value;
	
	imageList = "";
	
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
		success: function(response, opts) 
		{
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
		failure: function(response, opts)
		{
			alert(response.responseText);
		}
	});
}


//浏览图片
function queryPhoto(imageList)
{
    var arrImgFtp = new Array();		//用来存放需要显示图片的路径
    var lastDocID = '';				//用来记录上一次的docid,如果是历次,且lastDocID和当前docID不同,则增加表头
    var currItem = 0;				//记录当前取到第几个图片
    
    //串的结构为totImgaeCount$docID1^logsID1^printType1^imageCount1^hasTitle#docID2^logsID2^printType2^imageCount2^hasTitle
    var loglist = imageList.split('$')[1];
    var arrLog = loglist.split('#');
    
    //根据imglist产生arrImgFtp,用来显示图片
    for (var i = 0; i < arrLog.length; i++)		//由于数组从0开是,所以要-1
    {
		var docID = arrLog[i].split('^')[0];			//docID
		var logID = arrLog[i].split('^')[1];			//logID
		var printType = arrLog[i].split('^')[2];		//唯一还是历次,S:唯一,M:历次
		var imageCount = arrLog[i].split('^')[3];		//图片数量
		var imageHasTitle = arrLog[i].split('^')[4];		//是否有表头
		
		//根据图片数量,循环取图片，并存到数组arrImgFtp里
		for (var j = 1; j <= imageCount; j++)
		{
			currItem++;		//循环一次,currItem自增
			//若当前取的图片在开始index和结束index之外,跳出当前循环
			if (currItem < startIndex || currItem > endIndex)
			{
				continue;
			}
			//如果是否是历次,增加表头
			if (printType == 'M' && lastDocID != docID && imageHasTitle == '1')
			{
				arrImgFtp = arrImgFtp.concat('epr.newfw.eprbrowserredirect.csp?patientID=' + patientID + '&episodeID=' + episodeID + '&logID=' + 'title' + '&picName=' + docID);
			}
		
			arrImgFtp = arrImgFtp.concat('epr.newfw.eprbrowserredirect.csp?patientID=' + patientID + '&episodeID=' + episodeID + '&logID=' + logID + '&picName=' + j.toString());
			lastDocID = docID;		//设置上次docID的值
		}
    }
    
	frames['frameBrowserPhotoNew'].document.getElementById('browserPhoto').innerHTML = "";
	
	var table = '<table cellpadding="0" cellspacing="0">'
	for(var i = 0; i < arrImgFtp.length; i++)				
	{
		table +='<tr><td><img src="' + arrImgFtp[i] + '"/></td></tr>'
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
	
	
	queryPhoto(imageList);
	
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
	
	queryPhoto(imageList);
	
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
