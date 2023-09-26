
//��дalert
window.alert = function(msg, callback){
	layer.alert(msg, function(index){
		layer.close(index);
		if(typeof(callback) === "function"){
			callback("ok");
		}
	});
}

//jqueryȫ������
$.ajaxSetup({
	dataType: "json",
	cache: false,
    contentType: "application/json",
    complete: function(xhr) {
    }
});

var baseURL = "dhcapp.broker.csp?ClassName=web.DHCEMVEUTest&MethodName=JsonQryInci";;

var Main = {
	data: function(){
		return{
			tableData:[],
			currentRow: null,
            formData:{},
            formQuery:{},
            showList:true,
			sizes:[200,400,600,800,1000],
            total:0,
            page:{
                limit:200,
                page:1
            },
            form: {
	          name: '',
	          region: '',
	          date1: '',
	          date2: '',
	          delivery: false,
	          type: [],
	          resource: '',
	          desc: ''
	        }
	    }
	},
	methods:{
		// �е���
		handleRowClick:function(val){
			this.currentRow = val;
		},
		// ��ѯ
        handleQuery:function(){
            var index = layer.load(1, {
			    shade: [0.5,'#fff'] //0.1͸���ȵİ�ɫ����
			});
            $.extend(this.formQuery, this.page)
            //var ret=$.ajax({url: baseURL + this.queryMethod,async: false,data: this.formQuery}).responseJSON;
            //this.tableData=ret.page.list;
            //this.total=ret.page.totalCount;
            var res = "";
            $.ajax({url: baseURL ,async: false,data: this.formQuery,success:function(result){
        	    res	= result
    		}})
            
            this.tableData=res.rows;
        	this.total=res.total;	
            layer.close(index)
        },
        // table ÿҳ�����ı�
		handlePageSizeChange:function(val){
			this.page.limit=val;
            this.handleQuery();
		},
		// table ��ҳ
		handlePageNoChange:function(val){
			this.page.page=val;
            this.handleQuery();
		},
		// ����
		add:function(){
			this.showList=false;
            this.form={};
            this.$refs['form'].resetFields();
		},
		// ����
		update:function(){
			
		},
		// ɾ��
		remove:function(){
			if(this.currentRow == null){
                alert("��ѡ��һ��")
                return true;
            }
			 this.$message({
	         	 message: '��ϲ�㣬����һ���ɹ���Ϣ',
	          	 type: 'success'
	        });	
		},
		// ��ѯ
		query:function(){
			this.handleQuery();
		},
		// ����
		onSubmit:function(){
			this.$message({
	         	 message: '���ܲ��ԣ������½��������Ϊ��' + this.form.name,
	          	 type: 'success'
	        });
		},
		//���ص�table ����
        handleBack:function(){
            this.showList=true;
            this.formData={};
        }
	}
}

/// ������
var Ctor = Vue.extend(Main);
var vm=new Ctor().$mount('#app');
//vm.handleQuery();