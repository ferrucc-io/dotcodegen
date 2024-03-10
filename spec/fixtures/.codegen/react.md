---
regex: 'client/.*\.tsx'
test_file_suffix: '.test.tsx'
instructions: '.codegen/instructions/react.md'
---

When writing a test, you should follow these steps:

1. Avoid typos.
2. Avoid things that could be infinite loops.
3. This codebase is React and Typescript, try to follow the conventions and patterns of React and Typescript.
4. Avoid dangerous stuff, like things that would show up as a CVE somewhere.
5. Use vitest for tests. It's a testing library that is used in this codebase.
6. Always import tests from test-utils/

Here's the skeleton of a test:

```Typescript

import "@testing-library/jest-dom";
import userEvent from "@testing-library/user-event";
import { Pagination } from "./Pagination";
import { render, screen } from "../../../../tests/testUtils";

describe("core/components/List/Pagination", () => {
  const mockNextPage = vi.fn();
  const mockPreviousPage = vi.fn();
  const setup = (currentPage = 1, lastPage = 5) => {
    const pagy = {
      page: currentPage,
      items: 10,
      count: 50,
      last: lastPage,
    };
    const pagination = {
      currentPage: currentPage,
      nextPage: mockNextPage,
      previousPage: mockPreviousPage,
    };
    render(
      <Pagination pagination={pagination} pagy={pagy} resourceName="items" />,
    );
  };

  test("renders pagination component correctly", () => {
    setup();
    expect(screen.getByText(/previous page/i)).toBeInTheDocument();
    expect(screen.getByText(/next page/i)).toBeInTheDocument();
    expect(screen.getByText(/1-10/i)).toBeInTheDocument();
    expect(screen.getByText(/out of 50/i)).toBeInTheDocument();
  });

  test("disables 'Previous page' button on first page", () => {
    setup(1);
    expect(screen.getByText(/previous page/i)).toBeDisabled();
  });

  test("enables 'Previous page' button on page greater than 1", () => {
    setup(2);
    expect(screen.getByText(/previous page/i)).toBeEnabled();
  });

  test("disables 'Next page' button on last page", () => {
    setup(5, 5);
    expect(screen.getByText(/next page/i)).toBeDisabled();
  });

  test("enables 'Next page' button before last page", () => {
    setup(4, 5);
    expect(screen.getByText(/next page/i)).toBeEnabled();
  });

  test("calls nextPage function when 'Next page' button is clicked", async () => {
    setup(1, 5);
    await userEvent.click(screen.getByText(/next page/i));
    expect(mockNextPage).toHaveBeenCalled();
  });

  test("calls previousPage function when 'Previous page' button is clicked", async () => {
    setup(2);
    await userEvent.click(screen.getByText(/previous page/i));
    expect(mockPreviousPage).toHaveBeenCalled();
  });
});

```