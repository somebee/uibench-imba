extern uibench

require 'imba'

tag uianim

	tag box
		prop time watch: :restyle

		def restyle
			dom:style:borderRadius = @time.toString + 'px'
			dom:style:background = "rgba(0,0,0,{0.5 + (@time / 10)})"
			self

		def end
			self

	def items array
		for item in array
			<box@{item:id}.AnimBox data-id=(item:id) time=(item:time % 10)>

	def render
		<self> items(@object:items)


tag uitable < table

	tag cell < td
		def end
			self

		def onclick e
			console.log "Clicked {text}"
			e.halt

	tag row < tr
		def cells array
			for item,i in array
				<cell@{i}.TableCell text=item>

		def render
			<self data-id=@object:id>
				<cell.TableCell text="#{@object:id}">
				cells @object:props

		def commit
			self

	def items array
		for item in array
			<row@{item:id}.TableRow .active=(item:active) object=item>

	def render
		<self> <tbody> items(@object:items)

tag uitree

	tag leaf < li
		def end do self

	tag node < ul

		def items array
			for child,i in array
				if child:container
					<node@{child:id}.TreeNode object=child>
				else
					<leaf@{child:id}.TreeLeaf text=child:id>

		def render
			<self> items(@object:children)

	def render
		<self> <node.TreeNode object=(@object:root)>

tag main
	def build
		self

	def render state, loc
		<self>
			if loc == 'table'
				<uitable.Table object=(state:table)>
			elif loc == 'anim'
				<uianim.Anim object=(state:anim)>
			elif loc == 'tree'
				<uitree.Tree object=(state:tree)>


uibench.init('Imba', '0.14.3')

document.addEventListener('DOMContentLoaded') do |e|
	var main = <main.Main>
	#App.append main

	var run = do |state| main.render(state, state:location)

	var pre = do |samples|
		#App.empty.append <pre> JSON.stringify(samples,null,4)

	uibench.run(run, pre)
