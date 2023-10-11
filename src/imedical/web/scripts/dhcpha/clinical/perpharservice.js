/// Descript:����ҩѧ�����ѯ
/// Creator: bianshuai
/// CreateDate: 2015-10-10
var url="dhcpha.clinical.action.csp";
$(function(){
	var EpisodeID = getParam("EpisodeID");
	var bsType = getParam("bsType")||"";
	var bsPoint = getParam("bsPoint")||"";
	LoadPerPharSerDetail(EpisodeID, bsType, bsPoint);
})

/// ���ظ���ҩѧ������ϸ
function LoadPerPharSerDetail(EpisodeID, bsType, bsPoint){
	$('#TTTT').treegrid({    
	    url: url+'?action=jsonPerPharServiceTree',  
	    idField:'id', 
	    treeField:'text',
	    fit:true,
	    queryParams:{EpisodeID:EpisodeID},
	    columns:[[    
	        {title:'id',field:'id',width:80,hidden:true},    
	        {field:'text',title:$g('������Ŀ'),width:250},
	        {field:'_parentId',title:'parentId',hidden:true},
	        {field:'bstype',title:'bsType',hidden:true}
	    ]],
	    onClickRow:function(rowData){   
		    var bsType=rowData.bstype;
		    var bsPoint=rowData.id;	
		    bsPoint=bsPoint.split("-"); //�ַ��ָ� 	 //qunianpeng 2017/8/14���ص�ID������-ID ��ֹeasyui������rowid�ظ�		
			LoadPerPharServiceDet(bsType,bsPoint[1]);
	    },
	    onLoadSuccess: function(row, data){
		    if(bsType&&bsPoint){
				LoadPerPharServiceDet(bsType,bsPoint);
				$('#TTTT').treegrid("select", bsType+"-"+bsPoint);
			}else{
				var tmpId,tmpBsType,tmpBsId;
				for(var i =0; i < data.rows.length; i++){
					if(!data.rows[i].children){
						continue;
					}
					tmpId = data.rows[i].children[0].id;
					tmpBsType = tmpId.split("-")[0];
					tmpBsId = tmpId.split("-")[1];
					if((typeof tmpBsType != "undefined")&&(typeof tmpBsId != "undefined")){
						break;
					}
				}
				LoadPerPharServiceDet(tmpBsType,tmpBsId);
				if(tmpId){
					$('#TTTT').treegrid("select", tmpId);
				}
			} 
		}   
	}); 
}

//������ϸ����
function LoadPerPharServiceDet(bsType,bsPoint){
	$.ajax({ 
        type: "POST", 
        url: 'dhcpha.clinical.action.csp', 
        data: "action=jsonLoadPerPharSerDet&bsType="+bsType+"&bsPoint="+bsPoint, 
        error: function (XMLHttpRequest, textStatus, errorThrown){
        }, 
        success: function (jsonString){
	       var JsonObj;
	       if(jsonString.trim() != "") {
		       JsonObj = jQuery.parseJSON(jsonString);
	       }
	       showContent(JsonObj);
        } 
    });
}

/// ��ʾ����
function showContent(contentObj){
	$('#mcontent').html("");
	var stheight = $('#mcontent').parent().parent().height() - 50;
	var htmlstr = '<div id="conItm">';
	if((typeof contentObj != "undefined")&&(contentObj.length)){
    	htmlstr = htmlstr + '<div style="text-align:center;padding:10px;">';
		htmlstr = htmlstr + '	<h1>'+contentObj[0].bstitle+'</h1>';
		htmlstr = htmlstr + '	<span>'+$g("���ڣ�")+'<span class="ui-font11">'+contentObj[0].bsdate+" "+contentObj[0].bstime+'</span>  '+$g("���˵ǼǺţ�")+'<span class="ui-font11">'+contentObj[0].patno+'</span>   '+$g("������")+'<span class="ui-font11">'+contentObj[0].patname+'</span> '+$g("��д�ˣ�")+'<span class="ui-font11">'+contentObj[0].bsuser+'</span></span>';
		htmlstr = htmlstr + '</div>';
		for (var i=1;i<contentObj.length;i++){
			htmlstr = htmlstr + '<div>';
			/// ����
			htmlstr = htmlstr + '	<div>';
			htmlstr = htmlstr + '		<span class="ui-font14">'+i+'��' + contentObj[i].bstitle;
			htmlstr = htmlstr + '		</span>';
			htmlstr = htmlstr + '	</div>';
			/// ����
			htmlstr = htmlstr + '	<div style="margin:15px;font-size:16px;line-height:28px;">';
			htmlstr = htmlstr + 		contentObj[i].bscontent;
			htmlstr = htmlstr + '	</div>';
			htmlstr = htmlstr + '</div>';
		}
	}else{
		htmlstr += '<div style="text-align:center;padding:10px;">';
		htmlstr += '	<span>'+$g("��ʾ��û�����������")+'</span>';
		htmlstr += '</div>';
	}
	htmlstr += "</div>"
	$('#mcontent').html(htmlstr);
	var height = $('#conItm').height();
	if(stheight > height){
		$('#conItm').height(stheight);
	}
}