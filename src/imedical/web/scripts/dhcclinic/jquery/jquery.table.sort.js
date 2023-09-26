/**
 * jquery�����
 * @author ZouHao
 * @param ascImgUrl  ����ͼƬ��ַ
 * @param descImgUrl ����ͼƬ��ַ
 * ����:
 * 1:Ĭ��ʹ���﷨
 * $("table").sort();
 * 2:����ʹ���﷨
 * $("table").sort({
 * 		'ascImgUrl':'/static/images/bullet_arrow_up.png',
		'descImgUrl':'/static/images/bullet_arrow_down.png',
		'endRow':0,		//���һ��
		'isHeaderTh':true    //ͷ����th����td
 * });
 */
;(function ($) {  
	$.fn.sort = function (options) {  
		var settings = $.extend({
			'ascImgUrl':'/static/images/bullet_arrow_up.png', //����ͼƬ
			'descImgUrl':'/static/images/bullet_arrow_down.png', //����ͼƬ
			'endRow':0,		//���һ��
			'isHeaderTh':true    //ͷ����th����td
		},options);
		init(this);
		function init(p){
			//��ʼ��һЩ����
			var node=settings.isHeaderTh?'th':'td';
			var trList=$(p).find("tr "+node+"[sort='true']");
			if(settings.endRow==0){
				settings.endRow=$(p).find("tr").size();
			}else if(settings.endRow<0){
				settings.endRow=$(p).find("tr").size()+settings.endRow;
			}else{
				settings.endRow=$(p).find("tr").size()-settings.endRow;
			}
			//��ʼ��������ͷ���¼�
			trList.click(function(){
				//��ȡ��ǰ����
				settings.startRow=$(this).parent().index();
				settings.index=$(this).index();
				UpdateSort(p,this,settings,trList);
			});
			//��ʼ��ͷ��ͼƬ
			addImg(trList);
		}
		function UpdateSort(p,col,settings,trList){
			if($(col).find("img").size()==2){
					addImg(trList);
					removeImg(col,'asc');
					changeTableBody(p,'asc');
				}else{
					imgUrl=settings.ascImgUrl;
					imgUrl=imgUrl.split('/')[imgUrl.split('/').length-1];
					if($(col).find("img").attr("src").indexOf(imgUrl)>0){
						addImg(trList);
						removeImg(col,'desc');
						changeTableBody(p,'desc');
					}else{
						addImg(trList);
						removeImg(col,'asc');
						changeTableBody(p,'asc');
					}
				}
		}
		//�����ݽ�������
		function changeTableBody(p,sort){
			data=new Array();
			//��ѡ����
			var trBodyList=$(p).find("tr:lt("+settings.endRow+"):gt("+settings.startRow+")");
			trBodyList.each(function(i){
				data[i]=new Array();
				$(this).find("td").each(function(j){
					data[i][j]=$(this).html();
				});
			});
			data.sort(function(x, y){  
				var a=$(x[settings.index]).text();
				var b=$(y[settings.index]).text();
				if(!isNaN(a) && !isNaN(a)){
					a=parseFloat($(x[settings.index]).text());
					b=parseFloat($(y[settings.index]).text());
					//return a-b;
					if(sort=='asc') return a-b;
					else return b-a;
				}
				if(sort=='asc'){
					return a.localeCompare(b);  
				}else{
					return b.localeCompare(a);  
				}
			});
			trBodyList.each(function(i){
				$(this).find("td").each(function(j){
					$(this).html(data[i][j]);
				});
			});
		}
		/**
		 * Ϊÿ�����ͷ�����ͼƬ
		 */
		function addImg(trList){
			trList.find("img").remove();
			trList.append('<img src="'+settings.ascImgUrl+'" style="width:8px;height:8px;" /><img src="'+settings.descImgUrl+'" style="width:8px;height:8px;" />')
		}
		/**
		 * �Ƴ���ǰ����������/����ͼƬ
		 */
		function removeImg(p,sort){
			var imgUrl=sort=='desc'?settings.ascImgUrl:settings.descImgUrl;
			imgUrl=imgUrl.split('/')[imgUrl.split('/').length-1];
            $(p).find("img").each(function () {
                if ($(this).attr("src").indexOf(imgUrl)>0) {
                    $(this).remove();
                    return false;
                }
            });
		}
	};  
})(jQuery); 
