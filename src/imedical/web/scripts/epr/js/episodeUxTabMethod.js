var pathList = "";
var table = '<table cellpadding="0" cellspacing="0">';
var currentPage = 1;
var pageSize = 10;
var pageCount = 0;
var arr = new Array();
var picLength = 0;

//调用dll下载图片
function queryPhoto(imageList)
{
	//alert("D+"+imageList);
	var list = imageList.split('@');
	for(var i=0;i<list.length;i++)
	{
	    if(list[i].split(',')[0]=="NoPower")
	    {
	         table +='<tr><td>对不起,您没有权限浏览'+ list[i].split(',')[1] +'！</td></tr>';
	    }
	    else if(list[i].split(',')[0]=="docIdListnull"||list[i].split(',')[0]=="logIdListnull"||list[i].split(',')[0]=="")
	    {
	        table +='<tr><td>没有找到'+ list[i].split(',')[1] +'相关图片！</td></tr>';
	    }
	    else
	    {
	        var path = "";
	        var startIndex = 1;
			var TypeAndCount = list[i].split('$')[0];
			var Type = TypeAndCount.split('&')[0];
			if (Type == "PhotoScan")
			{
				path = parent.parent.document.getElementById('imageloader').GetPhotoScan(list[i].split('$')[1]);
				
			}
			else
			{
				var endIndex = parseInt(TypeAndCount, 10)
			    path = parent.parent.document.getElementById('imageloader').GetPreviewImage(patientID, episodeID, list[i], startIndex, endIndex);
			}
	        if(path != "")
	        {
				if (pathList == "")
				{
					pathList = pathList + path;
				}
				else 
				{
					pathList = pathList + "^" + path;
				}
	        }
	    }
	}
	//debugger;
	//进行分页计算，并显示第一页内容
	arr =pathList.split('^');   		
	picLength = arr.length;
	parent.Ext.getCmp('picCount').setText('共'+picLength+'图');
	parent.Ext.getCmp('picCount').disable();
	parent.Ext.getCmp('displayMessage').disable();
	if ( picLength%pageSize == 0)
	{
		pageCount = picLength/pageSize;
	}
	else 
	{
		pageCount = Math.floor(picLength/pageSize) + 1;
	}
	parent.Ext.getCmp('pageCount').setText('共'+pageCount+'页');
	if (pageCount == 1)
	{
		parent.Ext.getCmp('btnPageDown').disable();
	}
	parent.Ext.getCmp('pageField').setValue(currentPage);
	parent.Ext.getCmp('btnPageUp').disable();
	//显示第一页
	queryPhotoByPage();
}

//显示某一页图片
function queryPhotoByPage()
{
	
	//alert("共"+pageCount+"页");
	//alert("第"+currentPage+"页");
	table = '<table cellpadding="0" cellspacing="0">';
	//最后一页
	if (currentPage == pageCount)
	{
		for(var j = (currentPage-1)*pageSize; j <picLength; j++)				
		{
			table +='<tr><td><img src="' + arr[j] + '"/></td></tr>'
			arrTmp = arrTmp.concat(arr[j]);
		}
		var startCount = (currentPage-1)*pageSize + 1 ;
		parent.Ext.getCmp('displayMessage').setText('当前显示第'+ startCount +'图到第'+ picLength +'图');
	}
	//非最后一页
	else
	{
		for(var j = (currentPage-1)*pageSize; j < currentPage*pageSize; j++)				
		{
			table +='<tr><td><img src="' +arr[j] + '"/></td></tr>'
			arrTmp = arrTmp.concat(arr[j]);
		}
		var startCount = (currentPage-1)*pageSize + 1 ;
		parent.Ext.getCmp('displayMessage').setText('当前显示第'+ startCount +'图到第'+ currentPage*pageSize +'图');
	}
	table += '<tr><td><a name="controlSroll"></a></td></tr></table>'
	//alert(table);
	document.getElementById('browserPhoto').innerHTML = table;
}

parent.Ext.getCmp('btnPageDown').on('click',function(){
	NextPage();
});
parent.Ext.getCmp('btnPageUp').on('click',function(){
	PrivPage();
});
parent.Ext.getCmp('GotoCurPage').on('click',function(){
	GotoCurPage();
});

function NextPage()
{
	currentPage = parseInt(parent.Ext.getCmp('pageField').getValue());
	//判断页码是否为字符串
	if (String(currentPage) == 'NaN' )
	{
		alert("页码只能为数字，请重新输入！");
		return;
	}
	if (currentPage < 1 || currentPage >= pageCount)
	{
		alert("页码超出范围，请重新输入！");
		return;
	}
	currentPage = currentPage + 1;
	parent.Ext.getCmp('pageField').setValue(currentPage);
	parent.Ext.getCmp('btnPageUp').enable();
	if (currentPage == pageCount)
	{
		parent.Ext.getCmp('btnPageDown').disable();
	}
	queryPhotoByPage();
}
function PrivPage()
{
	currentPage = parseInt(parent.Ext.getCmp('pageField').getValue());
	if (String(currentPage) == 'NaN' )
	{
		alert("页码只能为数字，请重新输入！");
		return;
	}
	if (currentPage <= 1 || currentPage > pageCount)
	{
		alert("页码超出范围，请重新输入！");
		return;
	}
	currentPage = currentPage - 1;
	parent.Ext.getCmp('pageField').setValue(currentPage);
	parent.Ext.getCmp('btnPageDown').enable();
	if (currentPage == 1)
	{
		parent.Ext.getCmp('btnPageUp').disable();
	}
	queryPhotoByPage();
}
function GotoCurPage()
{
	currentPage = parseInt(parent.Ext.getCmp('pageField').getValue());
	//页码跳转时的页码不符和要求时显示第一页
	if (String(currentPage) == 'NaN' )
	{
		alert("页码只能为数字，请重新输入！");
		return;
	}
	
	if (currentPage < 1 || currentPage > pageCount)
	{
		alert("页码超出范围，请重新输入！");
		return;
	}
	parent.Ext.getCmp('pageField').setValue(currentPage);
	if (currentPage == pageCount)
	{
		parent.Ext.getCmp('btnPageDown').disable();
		parent.Ext.getCmp('btnPageUp').enable();
	}
	else if (currentPage == 1)
	{
		parent.Ext.getCmp('btnPageUp').disable();
		parent.Ext.getCmp('btnPageDown').enable();
	}
	else
	{
		parent.Ext.getCmp('btnPageUp').enable();
		parent.Ext.getCmp('btnPageDown').enable();
	}
	queryPhotoByPage();
}

if (canPrintPic!="Y")
{
	parent.Ext.getCmp('btnPrintPic').disable();
}

parent.Ext.getCmp('btnPrintPic').on('click',function(){
	printPics();
});

/// 调用dll打印图片
function printPics()
{
	parent.parent.document.getElementById('imageloader').printPics(pathList)
}
