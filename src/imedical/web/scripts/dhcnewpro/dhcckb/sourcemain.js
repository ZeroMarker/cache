function initPageDefault(){
	PageDefault();
	
	}

function PageDefault(){
	$('#tt3').tabs({ 
		border:false, 
		onSelect:function(title){ 	
			var iframe = null;// �õ�iframe
			if("֪ʶ��Դ����"==title){
				iframe = $('#first')[0];// �õ�iframe
			}
			if("Ŀ¼���ȼ�����"==title){
				iframe = $('#second')[0];// �õ�iframe
			}   
			if(iframe){
			iframe = (iframe.contentWindow || iframe.contentDocument);// �õ�iframe��������
			//console.log(iframe);
			iframe.location.reload(true); // ˢ������ҳ���б�
			
			}
		} 
	}); 
	}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
