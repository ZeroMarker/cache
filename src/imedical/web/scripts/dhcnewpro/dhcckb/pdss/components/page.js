/**
 * @description: js��ҳ
 * @param {*} el ��ҳ����
 * @param {*} count �ܼ�¼��
 * @param {*} pageStep ÿҳ��ʾ���ٸ�
 * @param {*} pageNum  pageNum:�ڼ�ҳ
 * @param {*} fnGo  ��ҳ��ת����    
 * @return {*}
 */        

(function (window) {
    
    var jsPage = function (el, pageStep, pageNum, fnGo, option,callback) {
	    
	    this.callback=callback;
		// ����ķ�������
	    var drugData = {}; 
	    // ��ҳ��
	    var count = 0;
	    
	    // ���ط���
	    this.loadDrugList = function(option){
		    var params = option.params;
		    var type = params.type;
		    var input = params.input;
		    var userInfo = params.userInfo;
		    var cattype = params.cattype;
		    if (input == ""){
				return;
			}						
			runClassMethod("web.DHCCKBPdssIndex","queryDrugListByType",{"page":pageNum,"rows":pageStep,"queryType":type,"queryStr":input,"userInfo":userInfo,"cattype":cattype},function(res){
				drugData = res;
				count = drugData.total;
			},'json',false);				
		}
	    	   	    
	    // ��ҳ�л��¼�
        this.getLink = function (index, pageNum, text) {
            //var s = '<a href="#p' + index + '" onclick="' + fnGo + '(' + index + ','+ count + ');" ';  
            var goNum = (text=="��ҳ")?1:(text=="ĩҳ"?Math.ceil(count / pageStep):index);
            var s = '<a ' + index + '" onclick="' + 'togglePage' + '('+goNum+');" ';  
            if (text||"") {
                if ((text.indexOf('��ҳ') != -1) || (text.indexOf('ĩҳ') != -1)){
                    s += 'class="tippage" ';
                }               
            }
            else {
                if (index == pageNum) {
                    s += 'class="aselect" ';
                }
                text = text || index;
              
            }
            s += '>'+ text + '</a> ';
            return s; 
        }
        
        // �л�
        this.togglePage = function(goNum){
	        	        
	        pageNum = goNum;	        
	        this.loadDrugList(option);
	         //��ҳ��
	        var pageNumAll = Math.ceil(count / pageStep);
	        
	        if (pageNumAll == 1) {
	            //document.getElementById(el).innerHTML = '';
	            //return;
	        }	        
	        var s = '<span>��'+pageNumAll+'ҳ����ת<input type="text" id="skipPage" onblur="skipPage(this)"/>ҳ</span>';
	        // ��ҳ��ĩҳĬ�ϴ���
	        s += this.getLink(1, pageNum, '��ҳ');
	        // if (pageNumAll > 1) {
	        //     s += this.getLink(fnGo, 1, pageNum, '��ҳ');
	        // }
	        var itemNum = 3; //��ǰҳ����������ʾ����
	        pageNum = Math.max(pageNum, 1);
	        pageNum = Math.min(pageNum, pageNumAll);      
	        if (pageNum > 1) {           
	            s += this.getLink(pageNum - 1, pageNum, '&lt;');
	        } 
	        var begin = 1;
	        if (pageNum - itemNum > 1) {
	            s += this.getLink(1, pageNum) + '... ';
	            begin = pageNum - itemNum;
	        }
	        var end = Math.min(pageNumAll, begin + itemNum * 2);
	        if (end == pageNumAll - 1) {
	            end = pageNumAll;
	        }
	        
	        for (var i = begin; i <= end; i++) {
	            s += this.getLink(i, pageNum);
	        }
	        if (end < pageNumAll) {
	            s += '... ' + this.getLink(pageNumAll, pageNum);
	        }
	        if (pageNum < pageNumAll) {
	            s += this.getLink(pageNum + 1, pageNum, '&gt;');
	            // s += this.getLink(fnGo, pageNumAll, pageNum, 'ĩҳ');
	        }
	        s += this.getLink(pageNumAll, pageNum, 'ĩҳ');
	        var divPage = document.getElementById(el);
	        divPage.innerHTML = s;
	        if (pageNumAll == 1) {
	            divPage.innerHTML = '';
	            //return;
	        }
	       
	        this.callback(drugData,option);	      
	    }
    
    	// ִ�м������ݷ���
    	this.loadDrugList(option);
    	
    	// ִ�м������ݷ���
    	this.togglePage(pageNum);
    	
    	// ����ҳ����ת
    	this.skipPage = function(e){
	    	var num = e.value;
	    	if (num == ""){
		    	return;
		    }
	    	num = (num == undefined)?1:(parseInt(num)== "NaN")?1:parseInt(num);
	    	this.togglePage(num);
	    }
	    
	    $(document).on('keydown', "#skipPage", function(event){
		    var keyCode = event.keyCode||event.which;
			if(keyCode == "13"){
				$('#skipPage').blur();
			}
		});
    }   
    
    window.jsPage = jsPage;
})(this);
