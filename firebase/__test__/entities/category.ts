interface Category {
  title: string,
  reading: string,
}

export const createEmptyCategory: () => Category = () => {
  return {
    title: '',
    reading: '',
  }
}

export default Category;