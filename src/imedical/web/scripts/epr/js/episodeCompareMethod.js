
//调用dll下载图片
function queryPhoto(imageList, episodeID)
{
	//debugger;
	var path = "";
	var startIndex = 1;
	var arrTmp = new Array();	//存临时图片的路径
	
    var list = imageList.split('@');
    var table = '';;
    for(var i=0;i<list.length;i++)
    {
        if(list[i].split('$')[0] != 'NoImage')
	    {
	        
            if(list[i].split(',')[0]=="NoPower")
            {
                if(table=='')
                {
                    table = '<td style="border:1px solid #C7C7C7;" valign= "top" ><table cellSpacing=0 cellPadding=0>';
                }
                table +='<tr><td style="font-size:12px">对不起,您没有权限浏览'+ list[i].split(',')[1] +'！</td></tr>';
            }
            else if(list[i].split(',')[0]=="docIdListnull"||list[i].split(',')[0]=="logIdListnull"||list[i].split(',')[0]=="")
            {
                if(table=='')
                {
                    table = '<td style="border:1px solid #C7C7C7;" valign= "top" ><table cellSpacing=0 cellPadding=0>';
                }
                table +='<tr><td style="font-size:12px">没有找到'+ list[i].split(',')[1] +'相关病历！</td></tr>';
            }
            else
            {
                var endIndex = parseInt(list[i].split('$')[0], 10);
                
                //debugger;
                path = parent.frames['frmTabPanel'].document.getElementById('imageloader').GetPreviewImage(patientID, episodeID, list[i], startIndex, endIndex);
                //alert(path);
                if(path != "")
                {
	                var arr = path.split('^');
        		    
	                var picLength = arr.length;
	                for(var j = 0; j < picLength; j++)				
	                {
	                    if(table=='')
                        {
                            table = '<td style="border:1px solid #C7C7C7;" valign= "top" ><table cellSpacing=0 cellPadding=0>';
                        }
		                table +='<tr><td><img src="' + arr[j] + '"/></td></tr>'
		                arrTmp = arrTmp.concat(arr[j]);
	                }
        		   
                }
            }
            
            
	    }
	    else
	    {
	        var info = imageList.split("$")[1]; //取得【就诊日期】、【就诊类型】、【科室】信息
	        var array = info.split("^");
	        table = '<td valign= "top" ><table cellSpacing=0 cellPadding=0 style="width:300px">';
	        table +='<tr><td style="font-size:12px">日期：' + array[0] + '<br />类型：' + array[1] + '<br />科室：' + array[2] + '<br />没有找到相关病历！</td></tr>';

	    }
        
	}
	table +='</table></td>';
	$('#compareTR').append(table);
	
}