

//调用dll下载图片
function queryPhoto(imageList)
{
	var path = "";
	
	path = document.getElementById('imageloader').GetPreviewImage(patientID, episodeID, imageList, startIndex, endIndex);

	if(path != "")
	{
		var arr = path.split('^');
		var table = '<table cellpadding="0" cellspacing="0">';
		var picLength = arr.length;
		for(var i = 0; i < picLength; i++)				
		{
			table +='<tr><td><img src="' + arr[i] + '"/></td></tr>'
			//将arrTmp[i + arrTmp.length] = arr[i] 该为arrTmp = arrTmp.concat(arr[i]), 2009-9-7
			//arrTmp[i + arrTmp.length] = arr[i];
			arrTmp = arrTmp.concat(arr[i]);
		}
		
		table += '</table>'
		frames['frameBrowserPhoto'].document.getElementById('browserPhoto').innerHTML = table;
		
		
	}
	
}