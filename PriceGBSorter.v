module main

import net.http
import x.json2
import regex

struct HDD {
	name string
	price f32
	size int
	permalink string
}

fn main() {
	println('Hello World!')
	mut request := http.Request{
		url: "https://api.mercadolibre.com/sites/MLA/search?category=MLA1672",
		method: http.Method.get
	}
	request.add_header(http.CommonHeader.authorization, "Bearer TG-6163150ead3e6b000762d365-134063224")
	response := request.do() ?

	query := r'[\d]+(?:\.|,[\d]{1,4})?\s*(?P<denom>(TB)|(GB))'
	mut re := regex.regex_opt(query) or { panic(err) }
	println(re.get_query())
	//re.compile_opt() ?

	raw := json2.raw_decode(response.text) ?
	mapped := raw.as_map()
	//println(response.text)

	mut str := ""
	mut products := []HDD { cap: 100 }
	for product in mapped['results']?.arr() {
		//println(mapped['results']?.arr())
		pmap := product.as_map()
		str = pmap['title']?.str()
		println(str)
		start, end := re.find(str.to_upper())
		println(start)
		println(end)
		if start != -1 {
			println(str[start..end])
			println(str[start..end-2])
			println(str[end-2..end])

			mut permalink := pmap['permalink']?.str()
			mut price := pmap['price']?.int()
			mut size := str[start..end-2].int()
			if str[end-2..end].to_upper() == "TB" {
				size *= 1024
			}

			mut tprod := HDD {
				name: str,
				size: size,
				price: price,
				permalink: permalink
			}
			products << tprod
			//products << HDD {
				//name: str,
				//size: size,
				//price: product.as_map()['price']?.int()
			//}
		}
	}

	products_sort := fn (a &HDD, b &HDD) int {
		aratio := a.price / a.size
		bratio := b.price / b.size

		if aratio > bratio {
			return 1
		} else if bratio > aratio {
			return -1
		} else {
			return 0
		}
	}

	//products.sort((a.price / a.size) > (b.price / b.size))
	products.sort_with_compare(products_sort)

	for product in products {
		println('$product.name: $product.size gb')
		println('\$$product.price: $product.permalink')
		println('Price/GB: ${product.price / product.size}')
	}
	//os.write_file("/data/data/com.termux/files/home/PriceGBSorterML/test.json", response.text) ?
	//println(response.text)
}
