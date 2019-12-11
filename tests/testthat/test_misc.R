context("Miscellaneous tests")

test_that("ggsave should save a *.tex file when used with 'device=tikzDevice::tikz", {
  ggsave_path = paste0(test_output_dir, "/ggsave.tex")
  if(file.exists(ggsave_path)) {
    file.remove(ggsave_path)
  }
  g = ggplot2::ggplot(data.frame())
  expect_error(ggplot2::ggsave(ggsave_path, g, device=tikzDevice::tikz), NA)
  expect_true(file.exists(ggsave_path))
})

test_that("closing tikz device with no output", {
  tikzDevice::tikz(onefile = FALSE)
  dev.off()
})
