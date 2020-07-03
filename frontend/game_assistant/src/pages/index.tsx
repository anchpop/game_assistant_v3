import * as React from 'react';
import { Link } from 'gatsby';
import Layout from '../components/layout';
import SEO from "../components/seo"

const HomePage = () => (
  <Layout>
    <SEO title="home" />
    <p>
      Hi! This is a place I'll try to put some resources that will be useful to
      people reading the book. I don't have much yet except{' '}
      <Link to="/diff-tool">this tool for diffing your code against the book code</Link>.
      Thanks for visiting!
    </p>
  </Layout>
);

export default HomePage;
