
extern uibench

require 'imba'

tag animbox

	def time= time
		if time == @time
			return self

		@time = time
		dom:style:borderRadius = (time % 10).toString + 'px'
		dom:style:background = 'rgba(0,0,0,' + (0.5 + ((time % 10) / 10)).toString() + ')'
		self

	def end
		self

tag uianim
	prop object watch: :render
	def end do self

	def items array
		for item in array
			<animbox@{item:id}.AnimBox time=(item:time)>

	def render
		<self> items(object:items)

tag uitablerow < tr
	prop object watch: :render
	def end do self

	def render
		<self .active=(object:active)>
			<td.TableCell text="#{object:id}">
			for item,i in object:props
				<td@{i}.TableCell text=item>


tag uitable < table
	prop object watch: :render
	def end do self

	def items array
		for item in array
			<uitablerow@{item:id}.TableRow object=item>

	def render
		<self> <tbody> items(object:items)

tag tree-node < ul
	prop object watch: :render
	def end do self

	def items array
		for child,i in array
			if child:container
				<tree-node@{child:id}.TreeNode object=child>
			else
				<li@{child:id}.TreeLeaf text="{child:id}">

	def render
		<self> items(object:children)
			

tag uitree
	prop object watch: :render
	def end do self

	def render
		<self> <tree-node.TreeNode object=(object:root)>

tag main
	prop object watch: :render
	def end do self

	def render
		var data = object
		var loc = data:location

		<self>
			if loc == 'table'
				<uitable.Table object=(data:table)>
			elif loc == 'anim'
				<uianim.Anim object=(data:anim)>
			elif loc == 'tree'
				<uitree.Tree object=(data:tree)>


uibench.init('Imba', '0.14.3')

document.addEventListener('DOMContentLoaded') do |e|
	var container = document.querySelector('#App')
	var main = <main.Main>

	container.appendChild(main.dom)

	var run = do |state|
		main.object = state
		# main.render

	var pre = do |samples|
		container:textContent = JSON.stringify(samples)
		self

	uibench.run(run, pre)

###
document.addEventListener('DOMContentLoaded', function(e) {
  var container = document.querySelector('#App');

  uibench.run(
      function(state) {
        ReactDOM.render(<Main data={state}/>, container);
      },
      function(samples) {
        ReactDOM.render(<pre>{JSON.stringify(samples, null, ' ')}</pre>, container);
      }
  );
});
###