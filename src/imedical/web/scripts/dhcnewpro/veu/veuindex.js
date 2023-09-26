
//重写alert
window.alert = function(msg, callback){
	layer.alert(msg, function(index){
		layer.close(index);
		if(typeof(callback) === "function"){
			callback("ok");
		}
	});
}

//jquery全局配置
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
		// 行单击
		handleRowClick:function(val){
			this.currentRow = val;
		},
		// 查询
        handleQuery:function(){
            var index = layer.load(1, {
			    shade: [0.5,'#fff'] //0.1透明度的白色背景
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
        // table 每页行数改变
		handlePageSizeChange:function(val){
			this.page.limit=val;
            this.handleQuery();
		},
		// table 翻页
		handlePageNoChange:function(val){
			this.page.page=val;
            this.handleQuery();
		},
		// 增加
		add:function(){
			this.showList=false;
            this.form={};
            this.$refs['form'].resetFields();
		},
		// 更新
		update:function(){
			
		},
		// 删除
		remove:function(){
			if(this.currentRow == null){
                alert("请选择一条")
                return true;
            }
			 this.$message({
	         	 message: '恭喜你，这是一条成功消息',
	          	 type: 'success'
	        });	
		},
		// 查询
		query:function(){
			this.handleQuery();
		},
		// 保存
		onSubmit:function(){
			this.$message({
	         	 message: '功能测试，不能新建！活动名称为：' + this.form.name,
	          	 type: 'success'
	        });
		},
		//返回到table 界面
        handleBack:function(){
            this.showList=true;
            this.formData={};
        }
	}
}

/// 构造器
var Ctor = Vue.extend(Main);
var vm=new Ctor().$mount('#app');
//vm.handleQuery();