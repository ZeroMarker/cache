//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2020-12-25
// ����:	   ֪ʶ����˲��JS
//===========================================================================================

var ID = "";  
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ҳ�����
	InitPageParams();
	
	/// ȡģ��Html
	GetRevPluginHtml();
	
}

/// ҳ�����
function InitPageParams(){
	
	ID = getParam("ID");
}

/// ȡģ��Html
function GetRevPluginHtml(){
	
	$(".form .list-order-item").html("");   /// ��Html
	runClassMethod("web.DHCCKBRevPlugin","GetRevPluHtml",{"ID":ID},function(jsonString){

		if (jsonString != ""){
			tempHtml = "<div>"+jsonString+"</div>";
			var htmlstr = "";
			htmlstr = htmlstr +'<div class="row row-select">';
			var rows = $(tempHtml).find('.row');
			for(var m=0; m<rows.length; m++){
				var els = $(rows[m]).find('label');
				for(var n=0; n<els.length; n++){
					$(els[n]).text("<%-" + $(els[n]).attr("data-id") + "%>").parent();
					htmlstr = htmlstr + $(els[n]).parent().html();
				}
			}
			htmlstr = htmlstr +'</div>';
			htmlstr = escape2Html(htmlstr);
			
			
			//$(".container").html(tempHtml);
			//var tempHtml = $(html).find('div[id=container]').html();
//			$(".container").html(tempHtml);   /// ��Html
//			$(tempHtml).find('label').each(function(){
//				$(this).text("\<%-" + $(this).attr("data-id") + "%\>");
//				//$(tempHtml).find('label[data-id="'+ $(this).attr("data-id") +'"]').replaceWith($(this).parent().text());
//			})
			//var tempHtml = $(".container").html();
		}
	},'',false)
}

function  escape2Html(str) {
  var  arrEntities={ 'lt' : '<' , 'gt' : '>' , 'nbsp' : ' ' , 'amp' : '&' , 'quot' : '"' };
  return  str.replace(/&(lt|gt|nbsp|amp|quot);/ig, function (all,t){ return  arrEntities[t];});
}
				
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })